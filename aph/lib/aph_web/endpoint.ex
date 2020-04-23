defmodule AphWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :aph
  use Sentry.Phoenix.Endpoint

  plug CORSPlug

  plug Plug.Static,
    at: "/static",
    from: :aph,
    gzip: false

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "aph",
    signing_salt: Application.get_env(:aph, :cookie_secret)

  socket "/live", Phoenix.LiveView.Socket

  plug AphWeb.Router
end
