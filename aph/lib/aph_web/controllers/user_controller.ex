defmodule AphWeb.UserController do
  use AphWeb, :controller

  import AphWeb.Authorize

  alias Aph.Accounts
  alias Aph.Accounts.User

  action_fallback AphWeb.FallbackController

  plug :user_check when action in [:update, :delete, :poll]

  def create(conn, %{"user" => user_params, "code" => code}) do
    with {:ok, changeset} <- Accounts.create_user(user_params, code),
         {:ok, _changeset} <- Accounts.update_invitation_with_user(changeset, code) do
      conn
      |> put_status(:ok)
      |> render(:show, user: changeset)
    else
      {:invitation_error, reason} ->
        conn
        |> put_status(:bad_request)
        |> put_view(AphWeb.ErrorView)
        |> render(:"400", message: reason)

      {:error, _} ->
        conn
        |> put_status(:bad_request)
        |> put_view(AphWeb.ErrorView)
        |> render(:"400", message: "Please check the values!")
    end
  end

  def poll(%Plug.Conn{assigns: %{current_user: user}} = conn, _attrs) do
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
