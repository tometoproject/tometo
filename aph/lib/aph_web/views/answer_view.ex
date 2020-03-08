defmodule AphWeb.AnswerView do
  use AphWeb, :view

  def render("answer.json", %{answer: answer}) do
    %{
      id: answer.id,
      content: answer.content,
      avatar_id: answer.avatar_id,
      question_id: answer.question_id
    }
  end
end
