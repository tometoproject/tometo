defmodule AphWeb.UserResetPasswordController do
  use AphWeb, :controller

  alias Aph.Accounts

  plug :get_user_by_reset_password_token when action in [:update]
  plug :put_view, AphWeb.UserView

  def create(conn, %{"user" => %{"email" => email}}) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(user, &frontend_reset_password_url(&1))
    end

    conn
    |> render(:message, message: "If your email exists, you'll receive instructions to reset your password shortly.")
  end

  def update(conn, %{"user" => user_params}) do
    case Accounts.reset_user_password(conn.assigns.user, user_params) do
      {:ok, _} ->
        conn
        |> render(:message, message: "Password reset successfully.")
      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> put_view(AphWeb.ErrorView)
        |> render(:bad_request, message: "Unable to change your password, please check its length.")
    end
  end

  defp get_user_by_reset_password_token(conn, _opts) do
    %{"token" => token} = conn.params

    if user = Accounts.get_user_by_reset_password_token(token) do
      conn |> assign(:user, user) |> assign(:token, token)
    else
      conn
      |> put_status(:bad_request)
      |> put_view(AphWeb.ErrorView)
      |> render(:invalid_input, message: "Link has expired or is invalid!")
    end
  end

  defp frontend_reset_password_url(token) do
    "#{Application.get_env(:aph, :frontend_hostname)}/reset_password/#{token}"
  end
end
