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

  alias Aph.Accounts.Invitation
  alias Aph.Accounts.Session
  alias Aph.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user(id), do: Repo.get!(User, id)

  def get_by(%{"session_id" => session_id}) do
    with %Session{user_id: user_id} <- get_session(session_id),
         do: Repo.get(User, user_id)
  end

  def get_by_username(username) do
    case Repo.get_by(User, username: username) do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, user}
    end
  end

  def create_user(attrs \\ %{}, code) do
    invitation = Repo.get_by(Invitation, code: code)
    is_required = Application.get_env(:aph, :require_invitations)
    user_count = Repo.one(from(u in User, select: count()))

    cond do
      # Basically rubber-stamp the registration if the appropriate config option
      # is set, for staging and testing purposes
      !is_required ->
        %User{}
        |> User.changeset(attrs)
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
        |> User.changeset(attrs)
        |> Repo.insert()
    end
  end

  def check_avatar(%User{} = user) do
    av = Repo.get_by(Aph.Main.Avatar, user_id: user.id)
    if(av, do: :ok, else: :error)
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
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

  #
  # SESSIONS
  #

  def list_sessions(user) do
    sessions = Repo.preload(user, :sessions).sessions
    Enum.filter(sessions, &(&1.expires_at > DateTime.utc_now()))
  end

  def get_session(id) do
    now = DateTime.utc_now()
    Repo.get(from(s in Session, where: s.expires_at > ^now), id)
  end

  def create_session(attrs \\ %{}) do
    %Session{}
    |> Session.changeset(attrs)
    |> Repo.insert()
  end

  def delete_session(%Session{} = session) do
    Repo.delete(session)
  end

  def delete_user_sessions(%User{} = user) do
    Repo.delete_all(from(s in Session, where: s.user_id == ^user.id))
  end

  def change_session(%Session{} = session) do
    Session.changeset(session, %{})
  end
end
