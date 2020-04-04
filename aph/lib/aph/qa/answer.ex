defmodule Aph.QA.Answer do
  @moduledoc """
  The Answer module.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "answers" do
    field :content, :string

    belongs_to :inbox, Aph.QA.Inbox
    belongs_to :question, Aph.QA.Question
    belongs_to :avatar, Aph.Main.Avatar

    timestamps()
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:content, :avatar_id, :question_id, :inbox_id])
    |> validate_required([:content, :avatar_id, :question_id, :inbox_id])
    |> validate_length(:content, max: 500)
    |> foreign_key_constraint(:inbox_id)
  end
end
