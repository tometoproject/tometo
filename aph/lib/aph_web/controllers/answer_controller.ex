defmodule AphWeb.AnswerController do
  @moduledoc """
  The Answer controller.

  Answers are created based on an Inbox. They're also connected to a User's Avatar.
  """
  use AphWeb, :controller

  import AphWeb.Authorize
  import Ecto.Query

  alias Aph.Main.Avatar
  alias Aph.QA
  alias Aph.QA.Answer
  alias Aph.QA.Question
  alias Aph.Repo

  action_fallback AphWeb.FallbackController

  plug :user_check when action in [:create, :update, :delete]

  def create(%Plug.Conn{assigns: %{current_user: user}} = conn, %{
        "content" => content,
        "inbox_id" => inbox_id
      }) do
    av = Repo.one(from(a in Avatar, where: a.user_id == ^user.id))

    if !av do
      conn
      |> put_status(:bad_request)
      |> put_view(AphWeb.ErrorView)
      |> render(:insufficient_input, message: "Create an avatar first!")
    end

    inbox = QA.get_inbox(inbox_id)

    if !inbox do
      conn
      |> put_status(:bad_request)
      |> put_view(AphWeb.ErrorView)
      |> render(:invalid_input, message: "You attempted to answer a nonexistent question!")
    end

    answer = %{
      content: content,
      avatar_id: av.id,
      inbox_id: inbox.id
    }

    with {:ok, answer} <- QA.create_answer(answer),
         {:ok, _} <- QA.update_inbox(inbox, %{answered: true}) do
      conn |> put_status(:created) |> render(:answer, answer: answer)
    end
  end

  def show(conn, %{"id" => id}) do
    answer = QA.get_answer(id)
    render(conn, :answer, answer: answer)
  end
end
