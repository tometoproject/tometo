defmodule AphWeb.UserController do
  use AphWeb, :controller

  import Ecto.Query

  alias Aph.Accounts
  alias Aph.QA.Inbox
  alias Aph.Repo

  action_fallback AphWeb.FallbackController

  def poll(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    if user.id != String.to_integer(id) do
      conn
      |> put_status(:forbidden)
      |> put_view(AphWeb.ErrorView)
      |> render(:wrong_user)
    end

    inboxes = Repo.one(from(i in Inbox, where: not i.answered, select: count(i.id)))

    case Accounts.check_avatar(user) do
      :ok -> conn |> put_status(:ok) |> render(:poll, has_avatar: true, inboxes: inboxes)
      :error -> conn |> put_status(:ok) |> render(:poll, has_avatar: false, inboxes: inboxes)
    end
  end
end
