use Mix.Config

config :aph,
  ecto_repos: [Aph.Repo]

config :aph, AphWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ym9e4r4KwYYerVHZkJxpoHC8vYcVQEELGyoIoLy8kcvol8cD67RvJdB8oV/ldlxH",
  render_errors: [view: AphWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Aph.PubSub, adapter: Phoenix.PubSub.PG2]

config :aph, AphWeb.Guardian,
  issuer: "aph",
  secret_key: "XsjICLNS/tqcS6lHj2L4D8srPeo2ZKrWSeDNTXVVwmpWyWHNveGatx/Pg7n49NT7"

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
