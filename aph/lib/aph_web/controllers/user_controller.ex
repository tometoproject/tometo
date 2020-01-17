defmodule AphWeb.UserController do
  use AphWeb, :controller

  import AphWeb.Authorize

  alias Aph.Accounts

  action_fallback AphWeb.FallbackController

  plug :user_check when action in [:poll]

  def create(conn, %{"user" => user_params, "code" => code}) do
    with {:ok, changeset} <- Accounts.create_user(user_params, code),
         {:ok, _changeset} <- Accounts.update_invitation_with_user(changeset, code) do
      conn
      |> put_status(:created)
      |> render(:show, changeset)
    else
      {:invitation_error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(AphWeb.ErrorView)
        |> render(:invalid_input, message: reason)

      {:error, _} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(AphWeb.ErrorView)
        |> render(:invalid_input, message: "Please check the values!")
    end
  end

  def poll(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    if user.id != String.to_integer(id) do
      conn
      |> put_status(:forbidden)
      |> put_view(AphWeb.ErrorView)
      |> render(:wrong_user)
    end

    case Accounts.check_avatar(user) do
      :ok -> conn |> put_status(:ok) |> render(:poll, has_avatar: true)
      :error -> conn |> put_status(:ok) |> render(:poll, has_avatar: false)
    end
  end
end
