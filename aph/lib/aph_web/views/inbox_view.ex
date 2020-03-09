defmodule AphWeb.InboxView do
  use AphWeb, :view
  alias AphWeb.InboxView
  alias AphWeb.QuestionView

  def render("show_many.json", %{inboxes: inboxes}) do
    render_many(inboxes, InboxView, "inbox.json")
  end

  def render("inbox.json", %{inbox: inbox}) do
    %{
      id: inbox.id,
      question: render_one(inbox.question, QuestionView, "question.json"),
      user_id: inbox.user_id
    }
  end
end
