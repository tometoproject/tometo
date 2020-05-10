defmodule Aph.Accounts.UserToken do
  use Ecto.Schema
  import Ecto.Query

  @hash_algorithm :sha256
  @rand_size 32

  @reset_password_validity_in_days 1
  @confirm_validity_in_days 7
  @change_email_validity_in_days 7
  @session_validity_in_days 60

  schema "users_tokens" do
    field :token, :binary
    field :context, :string
    field :sent_to, :string
    belongs_to :user, Aph.Accounts.User

    timestamps(updated_at: false, type: :utc_datetime)
  end

  @doc """
  Generates a token that can be stored in a signed place, like a session or cookie.
  Since they're signed, they don't need to be hashed.
  """
  def build_session_token(user) do
    token = :crypto.strong_rand_bytes(@rand_size)
    {token, %Aph.Accounts.UserToken{token: token, context: "session", user_id: user.id}}
  end

  @doc """
  Checks if the token is valid and returns its lookup query, which returns the user found by the token.
  """
  def verify_session_token_query(token) do
    query = from(token in token_and_context_query(token, "session"),
      join: user in assoc(token, :user),
      where: token.inserted_at > ago(@session_validity_in_days, "day"),
      select: user
    )

    {:ok, query}
  end

  @doc """
  Builds a token with a hashed counterpart.
  The non-hashed token is sent to the user email while the hashed part is stored in the database
  to avoid reconstruction. The token is valid for a week.
  """
  def build_user_email_token(user, context) do
    build_hashed_token(user, context, user.email)
  end

  defp build_hashed_token(user, context, sent_to) do
    token = :crypto.strong_rand_bytes(@rand_size)
    hashed_token = :crypto.hash(@hash_algorithm, token)

    {Base.url_encode64(token, padding: false),
     %Aph.Accounts.UserToken{
       token: hashed_token,
       context: context,
       sent_to: sent_to,
       user_id: user.id
     }}
  end

  @doc """
  Checks if the email token is valid and returns its lookup query.
  """
  def verify_user_email_token_query(token, context) do
    case Base.url_decode64(token, padding: false) do
      {:ok, decoded_token} ->
        hashed_token = :crypto.hash(@hash_algorithm, decoded_token)
        days = days_for_context(context)

        query = from(token in token_and_context_query(hashed_token, context),
          join: user in assoc(token, :user),
          where: token.inserted_at > ago(^days, "day") and token.sent_to == user.email,
          select: user)

        {:ok, query}
      :error ->
        :error
    end
  end

  defp days_for_context("confirm"), do: @confirm_validity_in_days
  defp days_for_context("reset_password"), do: @reset_password_validity_in_days

  @doc """
  Checks if the email change token is valid and returns its lookup query.
  """
  def verify_user_change_email_token_query(token, context) do
    case Base.url_decode64(token, padding: false) do
      {:ok, decoded_token} ->
        hashed_token = :crypto.hash(@hash_algorithm, decoded_token)

        query =
          from token in token_and_context_query(hashed_token, context),
            where: token.inserted_at > ago(@change_email_validity_in_days, "day")

        {:ok, query}
      :error ->
        :error
    end
  end


  @doc """
  Returns the token with context.
  """
  def token_and_context_query(token, context) do
    from(Aph.Accounts.UserToken, where: [token: ^token, context: ^context])
  end

  @doc """
  Gets all tokens for the user and context.
  """
  def user_and_contexts_query(user, :all) do
    from(t in Aph.Accounts.UserToken, where: t.user_id == ^user.id)
  end

  def user_and_contexts_query(user, [_ | _] = contexts) do
    from(t in Aph.Accounts.UserToken, where: t.user_id == ^user.id and t.context in ^contexts)
  end
end
