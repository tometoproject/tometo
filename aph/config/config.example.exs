use Mix.Config

# Main configuration for Aph
config :aph,
  ecto_repos: [Aph.Repo],
  tts: "espeak",
  hostname: "http://localhost:4001",
  cookie_secret: "9RGqJxYrnc3eoQHrDBBdZsSCMytNFWqgsvD572DfPcm2uH+ycGFye8ulrwaFi+zp",
  # This is only useful if you are using the "google" TTS strategy.
  google_key: "replaceme",
  require_invitations: false

# Database configuration for Aph. Additionally, you can set a password key here.
config :aph, Aph.Repo,
  username: "lu",
  database: "aph_dev",
  hostname: "localhost",
  # Set this to false in production
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# Configuration for Aph's job queue. This is where you would put in Redis credentials. The
# host, port and password keys are related to this (password is optional).
config :exq,
  name: Exq,
  host: "127.0.0.1",
  port: 6379,
  namespace: "aph:exq",
  concurrency: 200,
  queues: ["inbox"]

# Internal configuration, you probably don't need to edit this unless you want to
# change the port the application uses, or something like that
config :aph, AphWeb.Endpoint,
  render_errors: [view: AphWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Aph.PubSub, adapter: Phoenix.PubSub.PG2],
  http: [port: 4001],
  url: [host: "localhost"],
  secret_key_base: "ym9e4r4KwYYerVHZkJxpoHC8vYcVQEELGyoIoLy8kcvol8cD67RvJdB8oV/ldlxH",
  # This should be set to false in production
  debug_errors: true,
  # This too
  code_reloader: true,
  # And this should be set to true
  check_origin: false,
  watchers: [],
  server: true

config :phauxth,
  user_context: Aph.Accounts,
  token_module: AphWeb.Auth.Token

# This is the CORS configuration, you need to add the URL where your frontend is deployed
# to to this array. For example, if you change the port of your frontend in development,
# you're also going to need to change it here.
config :cors_plug,
  origin: ["http://localhost:1234"]

# Optional Sentry (https://sentry.io) configuration. This is pretty much useless in development
config :sentry,
  dsn: "AAAA",
  environment_name: "dev",
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  included_environments: ~w(staging prod)

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  # You might want to change this to :info in production
  level: :debug

config :phoenix, :json_library, Jason
