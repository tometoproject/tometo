defmodule Aph.Accounts do
  import Ecto.Query, warn: false
  alias Aph.Repo

  #
  # USERS
  #

  alias Aph.Accounts.User
  alias Aph.Accounts.Session

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

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
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

  alias Aph.Accounts.Invitation

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
