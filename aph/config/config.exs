use Mix.Config

config :aph,
  ecto_repos: [Aph.Repo]

config :aph, AphWeb.Endpoint,
  render_errors: [view: AphWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Aph.PubSub, adapter: Phoenix.PubSub.PG2]

config :phauxth,
  user_context: Aph.Accounts,
  token_module: AphWeb.Auth.Token

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
