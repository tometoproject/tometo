defmodule Aph.Accounts.Invitation do
  @moduledoc """
  The Invitation model.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "invitations" do
    field :code, :string
    belongs_to :created_user, Aph.Accounts.User, foreign_key: :created_by
    belongs_to :used_user, Aph.Accounts.User, foreign_key: :used_by

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(invitation, attrs) do
    invitation
    |> cast(attrs, [:code, :created_by, :used_by])
    |> validate_required([:code])
  end
end
