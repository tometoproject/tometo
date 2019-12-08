defmodule Aph.Repo do
  use Ecto.Repo,
    otp_app: :aph,
    adapter: Ecto.Adapters.Postgres
end
