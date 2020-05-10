use Mix.Config

# Main configuration for Aph
config :aph,
  tts: "espeak",
  hostname: "http://localhost:4001",
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
  pool_size: 1

config :aph, Aph.Mailer,
  adapter: Bamboo.LocalAdapter,
  open_email_in_browser_url: "http://localhost:4001/sent_emails"

# Configuration for Aph's job queue. This is where you would put in Redis credentials. The
# host, port and password keys are related to this (password is optional).
config :exq,
  name: Exq,
  host: "127.0.0.1",
  port: 6379,
  namespace: "aph:exq",
  concurrency: 200,
  queues: ["inbox"]

# Watch static and templates for browser reloading.
config :aph, AphWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/js/.*(js|css)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/meseta_web/templates/.*(eex)$"
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
