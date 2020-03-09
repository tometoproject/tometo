defmodule Aph.Main.Status do
  @moduledoc """
  The Status model.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "statuses" do
    field :content, :string
    field :related_status_id, :id
    belongs_to :avatar, Aph.Main.Avatar

    timestamps()
  end

  @doc false
  def changeset(status, attrs) do
    status
    |> cast(attrs, [:content, :avatar_id, :related_status_id])
    |> validate_required([:content, :avatar_id])
    |> validate_length(:content, max: 300)
  end
end
