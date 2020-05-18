use Mix.Config

config :aph, AphWeb.Endpoint,
  url: [host: "0.0.0.0", port: 4001],
  cache_static_manifest: "priv/static/cache_manifest.json"

config :aph, Aph.Mailer, adapter: Bamboo.PostmarkAdapter

config :sentry,
  environment_name: :prod,
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  tags: %{
    env: "production"
  },
  included_environments: ~w(staging prod)

config :logger, level: :info
