defmodule Aph.Accounts.Invitation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Aph.Accounts.User

  schema "invitations" do
    field :code, :string
    belongs_to :created_user, User, foreign_key: :created_by
    belongs_to :used_user, User, foreign_key: :used_by

    timestamps()
  end

  @doc false
  def changeset(invitation, attrs) do
    invitation
    |> cast(attrs, [:code, :created_by, :used_by])
    |> validate_required([:code])
  end
end
