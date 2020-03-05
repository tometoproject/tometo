defmodule AphWeb.Authorize do
  @moduledoc """
  Plugs that help verify that the user is logged in, or in a certain role.

  This is used to check whether the logged in user (automatically set by phauxth)
  has sufficient permission to access a route/action, or whether they're logged in
  at all.
  """

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
