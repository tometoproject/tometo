defmodule Aph.QA.Inbox do
  @moduledoc """
  The Inbox model.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "inboxes" do
    field :answered, :boolean, default: false
    belongs_to :question, Aph.QA.Question
    belongs_to :user, Aph.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def creation_changeset(inbox, attrs) do
    inbox
    |> cast(attrs, [:answered, :user_id, :question_id])
    |> validate_required([:user_id, :question_id])
    |> unique_constraint(:id)
  end

  def changeset(inbox, attrs) do
    inbox
    |> cast(attrs, [:answered])
    |> validate_required([:answered])
  end
end
