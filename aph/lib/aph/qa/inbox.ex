defmodule Aph.QA.Inbox do
  @moduledoc """
  The Inbox model.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "inboxes" do
    belongs_to :question, Aph.QA.Question
    belongs_to :user, Aph.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(inbox, attrs) do
    inbox
    |> cast(attrs, [:user_id, :question_id])
    |> validate_required([:user_id, :question_id])
  end
end
