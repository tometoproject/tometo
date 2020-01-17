defmodule AphWeb.Authorize do
  import Plug.Conn
  import Phoenix.Controller

  def user_check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    need_login(conn)
  end

  def user_check(conn, _opts), do: conn

  defp need_login(conn) do
    conn
    |> put_status(:unauthorized)
    |> put_view(AphWeb.ErrorView)
    |> render(:no_auth)
    |> halt()
  end
end
