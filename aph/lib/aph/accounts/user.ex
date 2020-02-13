defmodule Aph.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Aph.Main.Avatar
  alias Aph.Accounts.Session
  alias Aph.Accounts.Invitation

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string
    field :username, :string
    field :admin, :boolean, default: false
    field :mod, :boolean, default: false

    has_many :avatars, Avatar
    has_many :sessions, Session
    has_many :created_invitations, Invitation
    has_one :used_invitation, Invitation

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password])
    |> validate_required([:email, :username, :password, :admin, :mod])
    |> validate_format(:email, ~r/^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,10}$/)
    |> validate_length(:password, min: 6)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> put_hashed_password
  end

  def admin?(user), do: user.admin
  def mod?(user), do: user.mod

  defp put_hashed_password(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    put_change(changeset, :encrypted_password, Argon2.add_hash(password).password_hash)
  end

  defp put_hashed_password(changeset), do: changeset
end
