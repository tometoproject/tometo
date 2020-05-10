defmodule AphWeb.UserConfirmationController do
  use AphWeb, :controller

  alias Aph.Accounts

  plug :put_view, AphWeb.UserView

  def create(conn, %{"user" => %{"email" => email}}) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(user, &frontend_user_confirmation_url(&1))
    end

    conn
    |> render(:message, message: "If your email is registered and hasn't been confirmed yet, you will receive an email with instructions shortly.")
  end

  def confirm(conn, %{"token" => token}) do
    case Accounts.confirm_user(token) do
      {:ok, _} ->
        conn
        |> render(:message, message: "Email successfully confirmed!")
      :error ->
        conn
        |> put_status(:internal_server_error)
        |> put_view(AphWeb.ErrorView)
        |> render(:internal_error, message: "Error when confirming email address.")
    end
  end

  def frontend_user_confirmation_url(token) do
    "#{Application.get_env(:aph, :frontend_hostname)}/confirm/#{token}"
  end
end
