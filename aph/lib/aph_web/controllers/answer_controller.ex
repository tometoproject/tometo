defmodule AphWeb.AnswerController do
  use AphWeb, :controller

  import AphWeb.Authorize
  import Ecto.Query

  alias Aph.QA
  alias Aph.QA.Answer
  alias Aph.QA.Question
  alias Aph.Main.Avatar
  alias Aph.Repo

  action_fallback AphWeb.FallbackController

  plug :user_check when action in [:create, :update, :delete]

  def create(%Plug.Conn{assigns: %{current_user: user}} = conn, %{
        "content" => content,
        "question_id" => question_id
      }) do
    av = Repo.one(from(a in Avatar, where: a.user_id == ^user.id))
    if !av do
      conn
      |> put_status(:bad_request)
      |> put_view(AphWeb.ErrorView)
      |> render(:insufficient_input, message: "Create an avatar first!")
    end

    question = Repo.get(Question, question_id)
    if !question do
      conn
      |> put_status(:bad_request)
      |> put_view(AphWeb.ErrorView)
      |> render(:invalid_input, message: "You attempted to answer a nonexistent question!")
    end

    answer = %{
      content: content,
      avatar_id: av.id,
      question_id: question.id
    }
    with {:ok, answer} <- QA.create_answer(answer) do
      conn |> put_status(:created) |> render(:answer, answer: answer)
    end
  end
end
