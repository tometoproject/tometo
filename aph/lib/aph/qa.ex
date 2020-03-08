defmodule Aph.QA do
  @moduledoc """
  Context module for Question and Answer-related things.
  """

  alias Aph.Repo

  alias Aph.QA.Question
  alias Aph.QA.Answer
  alias Aph.QA.Inbox

  #
  # QUESTIONS
  #

  def get_question(id), do: Repo.get!(Question, id)

  def create_question(attrs \\ {}) do
    changeset = %Question{} |> Question.changeset(attrs)
    Repo.insert(changeset)
  end

  #
  # ANSWERS
  #

  def get_answer(id), do: Repo.get!(Answer, id)

  def create_answer(attrs \\ {}) do
    changeset = %Answer{} |> Answer.changeset(attrs)
    Repo.insert(changeset)
  end

  def update_answer(%Answer{} = answer, attrs) do
    answer
    |> Answer.changeset(attrs)
    |> Repo.update()
  end

  def delete_answer(%Answer{} = answer) do
    Repo.delete(answer)
  end

  #
  # INBOXES
  #

  def get_inbox(id), do: Repo.get!(Inbox, id)

  def delete_inbox(%Inbox{} = inbox) do
    Repo.delete(inbox)
  end
end
