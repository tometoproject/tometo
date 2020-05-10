defmodule Aph.QA.Comment do
  @moduledoc """
  The Comment module.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :content, :string

    belongs_to :answer, Aph.QA.Answer
    belongs_to :avatar, Aph.Main.Avatar

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :answer_id, :avatar_id])
    |> validate_required([:content, :answer_id, :avatar_id])
    |> validate_length(:content, max: 500)
  end

  @doc false
  def update_changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content])
    |> validate_required([:content])
    |> validate_length(:content, max: 500)
  end
end
