defmodule Aph.QA.Answer do
  @moduledoc """
  The Answer module.
  """

  use Ecto.Schema
  alias Aph.Main.Avatar
  alias Aph.QA.Question

  schema "answers" do
    field :content, :string

    belongs_to :question, Question
    belongs_to :avatar, Avatar
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:content])
    |> validate_required([:content])
    |> validate_length(:content, max: 500)
  end
end
