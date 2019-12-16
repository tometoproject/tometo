defmodule Aph.Main.Status do
  use Ecto.Schema
  import Ecto.Changeset
  alias Aph.Main.Avatar

  schema "statuses" do
    field :content, :string
    belongs_to :avatar, Avatar
    belongs_to :status, __MODULE__, foreign_key: :related_status_id
    has_many :statuses, __MODULE__

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
