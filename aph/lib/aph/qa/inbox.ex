defmodule Aph.QA.Inbox do
  @moduledoc """
  The Inbox model.
  """

  use Ecto.Schema
  import Ecto.Changeset
  import Aph.Accounts.User
  import Aph.QA.Question

  schema "inboxes" do
    belongs_to :question, Aph.QA.Question
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(inbox, attrs) do
    inbox
    |> cast(attrs, [:user_id, :question_id])
    |> validate_required([:user_id, :question_id])
  end
end
