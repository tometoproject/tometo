defmodule AphWeb.UserSessionController do
  use AphWeb, :controller

  alias Aph.Accounts
  alias AphWeb.UserAuth

  plug :put_view, AphWeb.UserView

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      IO.puts(user.confirmed_at)

      if user.confirmed_at do
        UserAuth.login_user(conn, user, user_params)
        |> render(:show, user: user)
      else
        conn
        |> put_status(:unauthorized)
        |> put_view(AphWeb.ErrorView)
        |> render(:no_confirmation)
      end
    else
      conn
      |> put_status(:bad_request)
      |> put_view(AphWeb.ErrorView)
      |> render(:invalid_input, message: "Invalid email or password!")
    end
  end

  def delete(conn, _params) do
    conn
    |> UserAuth.logout_user()
    |> render(:message, message: "Logged out successfully!")
  end
end
