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
  alias Aph.QA.Question

  action_fallback AphWeb.FallbackController

  plug :admin_check when action in [:create, :update, :delete]

  def create(%Plug.Conn{assigns: %{current_user: _}} = conn, %{
        "content" => content
      }) do
    with {:ok, question} <- QA.create_question(%{content: content}) do
      conn
      |> put_status(:created)
      |> render(:question, question: question)
    end
  end

  def show(conn, %{"id" => id}) do
    question = QA.get_question(id)
    render(conn, :question, question: question)
  end
end
