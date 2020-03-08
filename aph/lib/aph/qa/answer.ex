defmodule Aph.QA.Answer do
  @moduledoc """
  The Answer module.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Aph.Main.Avatar
  alias Aph.QA.Question

  schema "answers" do
    field :content, :string

    belongs_to :question, Question
    belongs_to :avatar, Avatar

    timestamps()
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:content, :avatar_id, :question_id])
    |> validate_required([:content, :avatar_id, :question_id])
    |> validate_length(:content, max: 500)
  end
end
