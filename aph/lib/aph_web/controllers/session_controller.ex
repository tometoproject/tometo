defmodule AphWeb.SessionController do
  use AphWeb, :controller

  import AphWeb.Authorize

  alias Phauxth.Remember
  alias Aph.Accounts
  alias Aph.Accounts.Session
  alias AphWeb.Auth.Login

  action_fallback AphWeb.FallbackController

  plug :user_check when action in [:delete]

  def create(conn, %{"username" => username, "password" => password, "remember_me" => remember}) do
    case Login.authenticate(%{username: username, password: password}) do
      {:ok, user} ->
        {:ok, %{id: session_id}} = Accounts.create_session(%{user_id: user.id})

        conn
        |> put_session(:phauxth_session_id, session_id)
        |> configure_session(renew: true)
        |> add_remember_me(user.id, remember)
        |> put_status(:created)
        |> render(:show, user: user, id: session_id)

      {:error, _err} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(AphWeb.ErrorView)
        |> render(:invalid_input, message: "Incorrect username or password!")
    end
  end

  def delete(%Plug.Conn{assigns: %{current_user: %{id: user_id}}} = conn, %{"id" => session_id}) do
    case Accounts.get_session(session_id) do
      %Session{user_id: ^user_id} = session ->
        Accounts.delete_session(session)

        conn
        |> delete_session(:phauxth_session_id)
        |> Remember.delete_rem_cookie()
        |> put_status(:ok)
        |> render(:success_delete)

      _ ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(AphWeb.ErrorView)
        |> render(:invalid_input, message: "Unknown session ID!")
    end
  end

  defp add_remember_me(conn, user_id, "true") do
    Remember.add_rem_cookie(conn, user_id)
  end

  defp add_remember_me(conn, _, _), do: conn
end
