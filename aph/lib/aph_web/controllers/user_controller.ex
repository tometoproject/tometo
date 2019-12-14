defmodule AphWeb.UserController do
  use AphWeb, :controller

  import AphWeb.Authorize

  alias Aph.Accounts
  alias Aph.Accounts.User
  alias AphWeb.Auth.Token

  action_fallback AphWeb.FallbackController

  plug :user_check when action in [:update, :delete, :poll]

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, %User{email: email} = user} ->
        conn
        |> put_status(:ok)
        |> render(:show, user: user)

      {:error, _changeset} ->
        conn
        |> put_status(:bad_request)
        |> put_view(AphWeb.ErrorView)
        |> render(:"400", message: "Please check the values!")
    end
  end

  def poll(%Plug.Conn{assigns: %{current_user: user}} = conn, attrs \\ {}) do
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
