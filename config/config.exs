use Mix.Config

# Main configuration for Aph
config :aph,
  ecto_repos: [Aph.Repo],
  cookie_secret: "9RGqJxYrnc3eoQHrDBBdZsSCMytNFWqgsvD572DfPcm2uH+ycGFye8ulrwaFi+zp"

# Internal configuration, you probably don't need to edit this unless you want to
# change the port the application uses, or something like that
config :aph, AphWeb.Endpoint,
  render_errors: [view: AphWeb.ErrorView, accepts: ~w(json)],
  pubsub_server: Aph.PubSub,
  http: [port: 4001],
  url: [host: "localhost"],
  secret_key_base: "ym9e4r4KwYYerVHZkJxpoHC8vYcVQEELGyoIoLy8kcvol8cD67RvJdB8oV/ldlxH",
  live_view: [signing_salt: "yVZYwiNje017IblQJYD1ndhXDbYGlW5m"],
  server: true

# This is the CORS configuration, you need to add the URL where your frontend is deployed
# to to this array. For example, if you change the port of your frontend in development,
# you're also going to need to change it here.
config :cors_plug,
  origin: ["http://localhost:4001"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
