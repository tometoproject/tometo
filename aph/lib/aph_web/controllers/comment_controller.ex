defmodule AphWeb.CommentController do
  @moduledoc """
  The Comment controller.

  Comments can be attached to an answer, but can be related to a different user.
  """
  use AphWeb, :controller

  import AphWeb.Authorize
  import Ecto.Query

  alias Aph.Main.Avatar
  alias Aph.QA
  alias Aph.QA.Answer
  alias Aph.QA.Comment
  alias Aph.Repo

  action_fallback AphWeb.FallbackController

  plug :user_check when action in [:create, :update, :delete]

  def create(%Plug.Conn{assigns: %{current_user: user}} = conn, %{
        "content" => content,
        "answer_id" => answer_id
      }) do
    av = Repo.one(from(a in Avatar, where: a.user_id == ^user.id))

    if !av do
      conn
      |> put_status(:bad_request)
      |> put_view(AphWeb.ErrorView)
      |> render(:insufficient_input, message: "Create an avatar first!")
    end

    answer = QA.get_answer(answer_id)

    if !answer do
      conn
      |> put_status(:bad_request)
      |> put_view(AphWeb.ErrorView)
      |> render(:invalid_input, message: "You attempted to comment on a nonexistent answer!")
    end

    comment = %{
      content: content,
      answer_id: answer.id,
      avatar_id: av.id
    }

    case QA.create_comment(comment) do
      {:ok, %Comment{} = comment} ->
        conn
        |> put_status(:created)
        |> render(:comment, comment: comment)
      {:error, err} ->
        conn
        |> put_status(:internal_server_error)
        |> put_view(AphWeb.ErrorView)
        |> render(:internal_error, message: err)
    end
  end
end
