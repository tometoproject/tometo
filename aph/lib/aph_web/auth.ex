defmodule AphWeb.Auth do
  alias Aph.Accounts

  def create_session(%Plug.Conn{assigns: %{current_user: %{id: user_id}}}) do
    Accounts.create_session(%{user_id: user_id})
  end
end

defmodule AphWeb.Auth.Login do
  alias Aph.Accounts

  def authenticate(%{username: username, password: password}) do
    case Accounts.get_by_username(username) do
      nil -> {:error, "No user found!"}
      {:error, reason} -> {:error, reason}
      {:ok, user} -> Argon2.check_pass(user, password, hash_key: :encrypted_password)
    end
  end
end

defmodule AphWeb.Auth.Token do
  @behaviour Phauxth.Token

  alias Phoenix.Token
  alias AphWeb.Endpoint

  @token_salt "user auth"

  def sign(data, opts \\ {}) do
    Token.sign(Endpoint, @token_salt, data, opts)
  end

  def verify(token, opts \\ {}) do
    Token.verify(Endpoint, @token_salt, token, opts)
  end
end
