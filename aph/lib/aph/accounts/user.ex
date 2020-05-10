defmodule Aph.Accounts.User do
  @moduledoc """
  The User model.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @derive {Inspect, except: [:password]}
  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string
    field :username, :string
    field :admin, :boolean, default: false
    field :mod, :boolean, default: false
    field :confirmed_at, :utc_datetime

    has_many :avatars, Aph.Main.Avatar
    has_many :inboxes, Aph.QA.Inbox
    has_many :tokens, Aph.Accounts.UserToken
    has_many :created_invitations, Aph.Accounts.Invitation, foreign_key: :created_by
    has_one :used_invitation, Aph.Accounts.Invitation, foreign_key: :used_by

    timestamps(type: :utc_datetime)
  end

  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password])
    |> validate_email()
    |> validate_username()
    |> validate_password()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,10}$/)
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, Aph.Repo)
    |> unique_constraint(:email)
  end

  defp validate_username(changeset) do
    changeset
    |> validate_required([:username])
    |> validate_length(:username, max: 40)
    |> unsafe_validate_unique(:email, Aph.Repo)
    |> unique_constraint(:username)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 80)
    |> prepare_changes(&hash_password/1)
  end

  defp hash_password(changeset) do
    password = get_change(changeset, :password)

    changeset
    |> put_change(:encrypted_password, Argon2.add_hash(password).password_hash)
    |> delete_change(:password)
  end

  def password_changeset(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password)
    |> validate_password()
  end

  def confirm_changeset(user) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)
    change(user, confirmed_at: now)
  end

  def valid_password?(%Aph.Accounts.User{encrypted_password: pwd}, password)
      when is_binary(pwd) and byte_size(pwd) > 0 do
    Argon2.verify_pass(password, pwd)
  end

  def valid_password?(_, _) do
    Argon2.no_user_verify()
  end

  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      false
    end
  end

  def admin?(user), do: user.admin
  def mod?(user), do: user.mod
end
