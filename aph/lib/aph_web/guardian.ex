defmodule AphWeb.Guardian do
  use Guardian, otp_app: :aph

  alias Aph.Accounts

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Accounts.get_user(id)
    {:ok, resource}
  end

  def authenticate(username, password) do
    with {:ok, user} <- Accounts.get_by_username(username) do
      case validate_password(password, user.encrypted_password) do
        true -> create_token(user)
        false -> {:error, :unauthorized}
      end
    end
  end

  defp validate_password(password, encrypted_password) do
    Argon2.verify_pass(password, encrypted_password)
  end

  defp create_token(user) do
    {:ok, token, _claims} = encode_and_sign(user, token_type: :refresh)
    {:ok, user, token}
  end
end

defmodule AphWeb.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :aph,
    module: AphWeb.Guardian,
    error_handler: AphWeb.AuthHandler

  plug Guardian.Plug.VerifyCookie
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end

defmodule AphWeb.AuthHandler do
  import Plug.Conn

  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{error: to_string(type)})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, body)
  end
end
