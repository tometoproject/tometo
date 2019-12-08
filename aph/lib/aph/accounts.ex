defmodule Aph.Accounts do
  import Ecto.Query, warn: false
  alias Aph.Repo

  alias Aph.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user(id), do: Repo.get!(User, id)

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
end
