defmodule AphWeb.Authorize do
  import Plug.Conn
  import Phoenix.Controller

  def user_check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    no_auth(conn)
  end

  def user_check(conn, _opts), do: conn

  def admin_check(%Plug.Conn{assigns: %{current_user: %{admin: false}}} = conn, _opts) do
    no_auth(conn)
  end

  def admin_check(conn, _opts), do: conn

  def mod_check(%Plug.Conn{assigns: %{current_user: %{mod: false}}} = conn, _opts) do
    no_auth(conn)
  end

  def mod_check(conn, _opts), do: conn

  defp no_auth(conn) do
    conn
    |> put_status(:unauthorized)
    |> put_view(AphWeb.ErrorView)
    |> render(:no_auth)
    |> halt()
  end
end
