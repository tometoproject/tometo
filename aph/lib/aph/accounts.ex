defmodule Aph.Accounts do
  @moduledoc """
  Context for things that are closely related to a user, such as login sessions
  and invitations.
  """

  import Ecto.Query, warn: false
  alias Aph.Repo

  #
  # USERS
  #

  alias Aph.Accounts.{Invitation, UserToken, UserNotifier, User}

  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  def get_user_by_username(username) do
    Repo.get_by(User, username: username)
  end

  def get_user_by_email_and_password(email, password) when is_binary(email) do
    user = Repo.get_by(User, email: email)
    if User.valid_password?(user, password), do: user
  end

  def get_user!(id), do: Repo.get!(User, id)

  def register_user(attrs \\ %{}, code) do
    invitation = Repo.get_by(Invitation, code: code)
    is_required = Application.get_env(:aph, :require_invitations)
    user_count = Repo.one(from(u in User, select: count()))

    cond do
      # Basically rubber-stamp the registration if the appropriate config option
      # is set, for staging and testing purposes
      !is_required ->
        %User{}
        |> User.registration_changeset(attrs)
        |> Ecto.Changeset.change(admin: user_count == 0)
        |> Repo.insert()

      !code ->
        {:invitation_error, "Please supply an invitation code!"}

      !invitation ->
        {:invitation_error, "No invitation found for that code!"}

      invitation.used_by ->
        {:invitation_error, "Invitation is already used!"}

      true ->
        %User{}
        |> User.registration_changeset(attrs)
        |> Repo.insert()
    end
  end

  def check_avatar(%User{} = user) do
    av = Repo.get_by(Aph.Main.Avatar, user_id: user.id)
    if av, do: :ok, else: :error
  end

  def change_user_registration(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs)
  end

  #
  # USER EMAIL CHANGE
  #

  def change_user_email(user, attrs \\ %{}) do
    User.email_changeset(user, attrs)
  end

  def apply_user_email(user, password, attrs) do
    user
    |> User.email_changeset(attrs)
    |> User.validate_current_password(password)
    |> Ecto.Changeset.apply_action(:update)
  end

  def update_user_email(user, token) do
    context = "change:#{user.email}"

    with {:ok, query} <- UserToken.verify_user_change_email_token_query(token, context),
         %UserToken{sent_to: email} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(user_email_multi(user, email, context)) do
      :ok
    else
      _ -> :error
    end
  end

  defp user_email_multi(user, email, context) do
    changeset = user |> User.email_changeset(%{email: email}) |> User.confirm_changeset()

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, [context]))
  end

  def deliver_update_email_instructions(%User{} = user, current_email, update_email_url_fun)
      when is_function(update_email_url_fun, 1) do
    {encoded_token, user_token} =
      UserToken.build_user_email_token(user, "change:#{current_email}")

    Repo.insert!(user_token)
    UserNotifier.deliver_update_email_instructions(user, update_email_url_fun.(encoded_token))
  end

  #
  # USER PASSWORD CHANGE
  #

  def change_user_password(user, attrs \\ %{}) do
    User.password_changeset(user, attrs)
  end

  def update_user_password(user, password, attrs) do
    changeset = user |> User.password_changeset(attrs) |> User.validate_current_password(password)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  #
  # USER SESSION
  #

  def generate_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  def delete_session_token(token) do
    Repo.delete_all(UserToken.token_and_context_query(token, "session"))
    :ok
  end

  #
  # USER CONFIRMATION
  #

  def deliver_user_confirmation_instructions(%User{} = user, confirmation_url_fun)
      when is_function(confirmation_url_fun, 1) do
    if user.confirmed_at do
      {:error, :already_confirmed}
    else
      {encoded_token, user_token} = UserToken.build_user_email_token(user, "confirm")
      Repo.insert!(user_token)

      UserNotifier.deliver_confirmation_instructions(user, confirmation_url_fun.(encoded_token))
    end
  end

  def confirm_user(token) do
    with {:ok, query} <- UserToken.verify_user_email_token_query(token, "confirm"),
         %User{} = user <- Repo.one(query),
         {:ok, %{user: user}} <- Repo.transaction(confirm_user_multi(user)) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  defp confirm_user_multi(user) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.confirm_changeset(user))
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, ["confirm"]))
  end

  #
  # USER RESET PASSWORD
  #

  def deliver_user_reset_password_instructions(%User{} = user, reset_password_url_fun)
      when is_function(reset_password_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_user_email_token(user, "reset_password")
    Repo.insert!(user_token)

    UserNotifier.deliver_password_reset_instructions(user, reset_password_url_fun.(encoded_token))
  end

  def get_user_by_reset_password_token(token) do
    with {:ok, query} <- UserToken.verify_user_email_token_query(token, "reset_password"),
         %User{} = user <- Repo.one(query) do
      user
    else
      _ -> nil
    end
  end

  def reset_user_password(user, attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.password_changeset(user, attrs))
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  #
  # INVITATIONS
  #

  def list_invitations do
    Repo.all(Invitation)
  end

  def get_invitation(id), do: Repo.get(Invitation, id)

  def get_invitation_by_code(code) do
    Repo.one(from(i in Invitation, where: i.code == ^code, preload: :created_user))
  end

  def create_invitation(attrs \\ %{}) do
    %Invitation{}
    |> Invitation.changeset(attrs)
    |> Repo.insert()
  end

  def update_invitation_with_user(%User{} = user, code) do
    is_required = Application.get_env(:aph, :require_invitations)
    invitation = Repo.get_by(Invitation, code: code)

    cond do
      !is_nil(invitation) and is_required ->
        invitation = Ecto.Changeset.change(invitation, used_by: user.id)
        Repo.update(invitation)

      !is_required ->
        {:ok, ""}

      true ->
        {:invitation_error, "No invitation found!"}
    end
  end

  def update_invitation(%Invitation{} = invitation, attrs) do
    invitation
    |> Invitation.changeset(attrs)
    |> Repo.update()
  end

  def delete_invitation(%Invitation{} = invitation) do
    Repo.delete(invitation)
  end

  def change_invitation(%Invitation{} = invitation) do
    Invitation.changeset(invitation, %{})
  end
end
