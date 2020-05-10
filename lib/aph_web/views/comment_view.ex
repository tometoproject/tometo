defmodule AphWeb.CommentView do
  use AphWeb, :view
  alias AphWeb.AvatarView
  alias AphWeb.CommentView

  def render("comments.json", %{comments: comments}) do
    render_many(comments, CommentView, "comment.json")
  end

  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.id,
      content: comment.content,
      answer_id: comment.answer_id,
      avatar: render_one(comment.avatar, AvatarView, "avatar.json"),
      audio: comment.audio,
      timestamps: comment.timestamps,
      pic1: comment.pic1,
      pic2: comment.pic2
    }
  end

  def render("comment_simple.json", %{comment: comment}) do
    %{
      id: comment.id,
      content: comment.content,
      answer_id: comment.answer_id,
      avatar_id: comment.avatar_id
    }
  end
end
