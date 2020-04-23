defmodule AphWeb.QuestionController do
  @moduledoc """
  The Question controller.

  Questions are pretty simple, they're just entities with a content field. They're
  not even associated with a user (not right now, at least, but probably later on).
  Only admins can create questions.
  """

  use AphWeb, :controller

  import AphWeb.Authorize

  alias Aph.QA

  action_fallback AphWeb.FallbackController

  plug :admin_check when action in [:create, :update, :delete, :list]

  def create(%Plug.Conn{assigns: %{current_user: _}} = conn, %{
        "content" => content,
        "date" => date
      }) do
    with {:ok, time} <- Timex.parse(date, "{ISO:Extended:Z}"),
         {:ok, question} <- QA.create_question(%{content: content}, time) do
      conn
      |> put_status(:created)
      |> render(:question, question: question)
    else
      {:error, err} ->
        conn
        |> put_status(:internal_server_error)
        |> put_view(AphWeb.ErrorView)
        |> render(:internal_error, message: err)
    end
  end

  def list(conn, %{}) do
    questions = QA.list_questions()
    render(conn, :questions, questions: questions)
  end

  def show(conn, %{"id" => id}) do
    question = QA.get_question(id)
    render(conn, :question, question: question)
  end
end
