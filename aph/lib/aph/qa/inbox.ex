defmodule Aph.QA.Inbox do
  @moduledoc """
  The Inbox model.
  """

  use Ecto.Schema
  import Aph.Accounts.User
  import Aph.QA.Question

  schema "inboxes" do
    belongs_to :question, Question
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(inbox, _), do: inbox
end
