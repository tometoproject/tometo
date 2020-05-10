import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :aph, Aph.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :aph, AphWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4001"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base,
  server: true

sentry_dsn =
  System.get_env("SENTRY_DSN") ||
  raise """
  environment variable SENTRY_DSN is missing.
  """

config :sentry,
  dsn: sentry_dsn

postmark_key =
  System.get_env("POSTMARK_API_KEY") ||
  raise """
  environment variable POSTMARK_API_KEY is missing.
  If you don't want to use Postmark for sending emails, use a different
  Bamboo email adapter in config/prod.exs and change the name
  of the environment variable to be loaded in config/releases.exs, and
  then assemble a new release.
  """

config :aph, Aph.Mailer,
  api_key: postmark_key
