defmodule AphWeb.UserController do
  use AphWeb, :controller

  alias Aph.Accounts
  alias Aph.Accounts.User
  alias AphWeb.Guardian

  action_fallback AphWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         {:ok, _token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render(:show, user: user)
    end
  end

  def login(conn, %{"username" => username, "password" => password}) do
    with {:ok, user, token} <- Guardian.authenticate(username, password) do
      conn
      |> put_status(:ok)
      |> AphWeb.Guardian.Plug.remember_me(user)
      |> render(:show, user: user)
    end
  end

  def logout(conn, attrs \\ {}) do
    # TODO: Make this more secure
    Guardian.Plug.clear_remember_me(conn)
  end

  def poll(conn, attrs \\ {}) do
    user = Guardian.Plug.current_resource(conn)

    case Accounts.check_avatar(user) do
      :ok -> conn |> put_status(:ok) |> render(:poll, has_avatar: true)
      :error -> conn |> put_status(:ok) |> render(:poll, has_avatar: false)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
