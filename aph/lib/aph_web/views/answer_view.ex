defmodule AphWeb.AnswerView do
  use AphWeb, :view
  alias AphWeb.AvatarView
  alias AphWeb.QuestionView

  def render("answer.json", %{answer: answer}) do
    %{
      id: answer.id,
      content: answer.content,
      avatar: render_one(answer.avatar, AvatarView, "avatar.json"),
      question: render_one(answer.question, QuestionView, "question.json"),
      audio: answer.audio,
      timestamps: answer.timestamps,
      pic1: answer.pic1,
      pic2: answer.pic2
    }
  end

  def render("answer_min.json", %{answer: answer}) do
    %{
      id: answer.id,
      content: answer.content,
      avatar_id: answer.avatar_id,
      inbox_id: answer.inbox_id
    }
  end
end
