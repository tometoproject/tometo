defmodule AphWeb.UserSettingsController do
  use AphWeb, :controller

  alias Aph.Accounts
  alias AphWeb.UserAuth

  plug :put_view, AphWeb.UserView
  plug :assign_email_and_password_changesets

  def update_email(conn, %{"current_password" => password, "user" => user_params}) do
    user = conn.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_update_email_instructions(
          applied_user,
          user.email,
          &frontend_confirm_updated_email_url(&1)
        )

        conn
        |> render(:message,
          message: "A link to confirm your email change has been sent to the new address."
        )

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> put_view(AphWeb.ErrorView)
        |> render(:invalid_input, message: "Please re-check your inputs!")
    end
  end

  def confirm_email(conn, %{"token" => token}) do
    case Accounts.update_user_email(conn.assigns.current_user, token) do
      :ok ->
        conn
        |> put_view(AphWeb.ErrorView)
        |> render(:message, message: "Password updated successfully.")

      :error ->
        conn
        |> put_status(:bad_request)
        |> put_view(AphWeb.ErrorView)
        |> render(:invalid_input, message: "Link has expired or is invalid!")
    end
  end

  def update_password(conn, %{"current_password" => password, "user" => user_params}) do
    user = conn.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        conn
        |> put_view(AphWeb.ErrorView)
        |> UserAuth.login_user(user)
        |> render(:message, message: "Password updated successfully.")

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> put_view(AphWeb.ErrorView)
        |> render(:invalid_input, message: "Please re-check your inputs!")
    end
  end

  defp assign_email_and_password_changesets(conn, _opts) do
    user = conn.assigns.current_user

    conn
    |> assign(:email_changeset, Accounts.change_user_email(user))
    |> assign(:password_changeset, Accounts.change_user_password(user))
  end

  defp frontend_confirm_updated_email_url(token) do
    "#{Application.get_env(:aph, :frontend_hostname)}/confirm_email/#{token}"
  end
end
