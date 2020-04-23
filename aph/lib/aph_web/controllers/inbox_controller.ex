defmodule AphWeb.InboxController do
  @moduledoc """
  The Inbox controller.

  Inboxes represent either unanswered or answered questions related to a single user.
  They don't actually contain any of the specifics an answer would have. They're
  created automatically by background processing whenever a new question is created,
  which is why there's not a lot in this controller — really the only thing that you
  can do with them that's public-facing is get their details.
  """

  use AphWeb, :controller

  import AphWeb.Authorize

  alias Aph.QA
  alias Aph.QA.Inbox

  action_fallback AphWeb.FallbackController

  plug :user_check when action in [:show, :show_for_user]
  plug :admin_check when action in [:delete]

  def show_for_user(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    if user.id != String.to_integer(id) do
      conn
      |> put_status(:unauthorized)
      |> put_view(AphWeb.ErrorView)
      |> render(:no_auth)
    end

    inboxes = QA.get_inbox_for_user(id)
    render(conn, :show_many, inboxes: inboxes)
  end

  def delete(conn, %{"id" => id}) do
    inbox = QA.get_inbox(id)

    with {:ok, %Inbox{}} <- QA.delete_inbox(inbox) do
      send_resp(conn, :no_content, "")
    end
  end
end
