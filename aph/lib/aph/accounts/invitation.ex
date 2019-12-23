defmodule Aph.Accounts.Invitation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invitations" do
    field :code, :string
    field :created_by, :id
    belongs_to :user, User, foreign_key: :used_by

    timestamps()
  end

  @doc false
  def changeset(invitation, attrs) do
    invitation
    |> cast(attrs, [:code, :created_by, :used_by])
    |> validate_required([:code])
  end
end
