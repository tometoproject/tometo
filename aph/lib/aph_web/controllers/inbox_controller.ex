defmodule AphWeb.InboxController do
  use AphWeb, :controller

  import AphWeb.Authorize
  import Ecto.Query

  alias Aph.Repo
  alias Aph.QA
  alias Aph.QA.Inbox
  alias Aph.QA.Question
  alias Aph.Accounts.User

  action_fallback AphWeb.FallbackController

  plug :user_check when action in [:delete, :show, :show_for_user]

  def show_for_user(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    if user.id != String.to_integer(id) do
      conn
      |> put_status(:unauthorized)
      |> put_view(AphWeb.ErrorView)
      |> render(:no_auth)
    end

    inboxes = Repo.all(from(i in Inbox, where: i.user_id == ^user.id, preload: :question))
    render(conn, :show_many, inboxes: inboxes)
  end

  def delete(conn, %{"id" => id}) do
    inbox = QA.get_inbox(id)

    with {:ok, %Inbox{}} <- QA.delete_inbox(inbox) do
      send_resp(conn, :no_content, "")
    end
  end
end
