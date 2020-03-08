defmodule AphWeb.QuestionView do
  use AphWeb, :view

  def render("question.json", %{question: question}) do
    %{
      id: question.id,
      content: question.content
    }
  end
end
