defmodule Aph.Accounts.Invitation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invitations" do
    field :code, :string
    field :created_by, :id
    field :used_by, :id

    timestamps()
  end

  @doc false
  def changeset(invitation, attrs) do
    invitation
    |> cast(attrs, [:code, :created_by])
    |> validate_required([:code, :created_by])
  end
end
