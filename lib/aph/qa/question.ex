defmodule Aph.QA.Question do
  @moduledoc """
  The Question model.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :content, :string
    has_many :inboxes, Aph.QA.Inbox

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:content])
    |> validate_required([:content])
    |> validate_length(:content, max: 500)
  end
end
