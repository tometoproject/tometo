defmodule AphWeb.CommentView do
  use AphWeb, :view

  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.id,
      content: comment.content,
      answer_id: comment.answer_id
    }
  end
end
