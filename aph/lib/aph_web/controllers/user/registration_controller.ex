defmodule AphWeb.UserRegistrationController do
  use AphWeb, :controller

  alias Aph.Accounts
  alias AphWeb.UserConfirmationController, as: Confirm

  plug :put_view, AphWeb.UserView

  def create(conn, %{"user" => user_params, "code" => code}) do
    with {:ok, changeset} <- Accounts.register_user(user_params, code),
         {:ok, _changeset} <- Accounts.update_invitation_with_user(changeset, code),
         {:ok, _} <-
           Accounts.deliver_user_confirmation_instructions(
             changeset,
             &Confirm.frontend_user_confirmation_url(&1)
           ) do
      conn
      |> put_status(:created)
      |> render(:show, user: changeset)
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
end
