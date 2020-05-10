defmodule AphWeb.QuestionView do
  use AphWeb, :view

  alias AphWeb.QuestionView

  def render("questions.json", %{questions: questions}) do
    render_many(questions, QuestionView, "question.json")
  end

  def render("question.json", %{question: question}) do
    %{
      id: question.id,
      content: question.content,
      inserted_at: question.inserted_at
    }
  end
end
