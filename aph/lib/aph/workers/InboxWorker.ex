defmodule Aph.InboxWorker do
  @moduledoc """
  This worker processes inbox creation requests.
  """

  import Ecto.Query
  alias Aph.Repo
  alias Aph.Accounts.User
  alias Aph.QA.Inbox
  alias Aph.QA.Question

  def perform(question_id, user_id) do
    existing_inbox =
      Repo.all(
        from(i in Inbox,
          where: i.question_id == ^question_id,
          where: i.user_id == ^user_id
        )
      )

    if Enum.empty?(existing_inbox) do
      inbox = %{
        answered: false,
        question_id: question_id,
        user_id: user_id
      }

      Aph.QA.create_inbox(inbox)
    end
  end
end
