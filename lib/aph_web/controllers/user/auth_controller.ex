defmodule AphWeb.UserAuth do
  @moduledoc """
  This module contains functions to manage user sessions.
  """
  import Plug.Conn
  import Phoenix.Controller

  alias Aph.Accounts

  @max_age 60 * 60 * 24 * 60
  @remember_me_cookie "user_remember_me"
  @remember_me_options [sign: true, max_age: @max_age, extra: "SameSite=Lax"]

  @doc """
  Logs the user in.
  """
  def login_user(conn, user, params \\ %{}) do
    token = Accounts.generate_session_token(user)

    conn
    |> renew_session()
    |> put_session(:user_token, token)
    |> maybe_write_remember_me_cookie(token, params)
  end

  defp maybe_write_remember_me_cookie(conn, token, %{"remember_me" => true}) do
    put_resp_cookie(conn, @remember_me_cookie, token, @remember_me_options)
  end

  defp maybe_write_remember_me_cookie(conn, _, _) do
    conn
  end

  def renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  def logout_user(conn) do
    user_token = get_session(conn, :user_token)
    user_token && Accounts.delete_session_token(user_token)

    conn
    |> renew_session()
    |> delete_resp_cookie(@remember_me_cookie)
  end

  def fetch_current_user(conn, _opts) do
    {user_token, conn} = ensure_user_token(conn)
    user = user_token && Accounts.get_user_by_session_token(user_token)
    assign(conn, :current_user, user)
  end

  defp ensure_user_token(conn) do
    if user_token = get_session(conn, :user_token) do
      {user_token, conn}
    else
      conn = fetch_cookies(conn, signed: [@remember_me_cookie])

      if user_token = conn.cookies[@remember_me_cookie] do
        {user_token, put_session(conn, :user_token, user_token)}
      else
        {nil, conn}
      end
    end
  end

  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> put_status(:unauthorized)
      |> put_view(AphWeb.ErrorView)
      |> render(:reverse_no_auth)
    else
      conn
    end
  end

  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(AphWeb.ErrorView)
      |> render(:no_auth)
    end
  end

  def require_admin_user(conn, _opts) do
    if conn.assigns[:current_user] && conn.assigns.current_user.admin do
      conn
    else
      conn
      |> put_view(AphWeb.ErrorView)
      |> render(:no_auth)
    end
  end

  def require_mod_user(conn, _opts) do
    if conn.assigns[:current_user] && conn.assigns.current_user.mod do
      conn
    else
      conn
      |> put_view(AphWeb.ErrorView)
      |> render(:no_auth)
    end
  end

  def require_admin_or_mod_user(conn, _opts) do
    if conn.assigns[:current_user] &&
         (conn.assigns.current_user.mod || conn.assigns.current_user.admin) do
      conn
    else
      conn
      |> put_view(AphWeb.ErrorView)
      |> render(:no_auth)
    end
  end
end
