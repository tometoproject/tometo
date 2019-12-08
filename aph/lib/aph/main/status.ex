defmodule Aph.Main.Status do
  use Ecto.Schema
  import Ecto.Changeset

  schema "statuses" do
    field :content, :string
    field :avatar_id, :id
    field :related_status_id, :id

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
