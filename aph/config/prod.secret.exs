# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
#
# You can set the following environment variables:
# - TTS_STRATEGY (required)
# - APH_HOSTNAME (required)
# - DATABASE_URL (required)
# - COOKIE_SECRET (required)
# - SENTRY_DSN
# - RELEASE_LEVEL (for Sentry)
# - GOOGLE_API_KEY
# - POOL_SIZE
# - PORT

use Mix.Config

google_key =
  System.get_env("GOOGLE_API_KEY") ||
    raise """
    environment variable GOOGLE_API_KEY is missing.
    This should be a Google Cloud service account API key.
    """

tts_strategy =
  System.get_env("TTS_STRATEGY") ||
    raise """
    environment variable TTS_STRATEGY is missing.
    This can be either "espeak" or "google".
    """

hostname =
  System.get_env("APH_HOSTNAME") ||
  raise """
  environment variable APH_HOSTNAME is missing.
  This should be the URL your frontend can reach Aph by.
  """

cookie_secret =
  System.get_env("COOKIE_SECRET") ||
    raise """
    environment variable COOKIE_SECRET is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :aph,
  tts: tts_strategy,
  hostname: hostname,
  google_key: google_key,
  cookie_secret: cookie_secret

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

sentry_dsn = System.get_env("SENTRY_DSN") || "aaaa"

config :sentry,
  dsn: sentry_dsn,
  environment_name: System.get_env("RELEASE_LEVEL") || "prod",
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  included_environments: ~w(staging prod)

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
  http: [:inet6, port: String.to_integer(System.get_env("PORT") || "4001")],
  secret_key_base: secret_key_base,

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :aph, AphWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
