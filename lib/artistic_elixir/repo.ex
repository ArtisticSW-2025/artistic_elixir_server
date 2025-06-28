defmodule ArtisticElixir.Repo do
  use Ecto.Repo,
    otp_app: :artistic_elixir,
    adapter: Ecto.Adapters.Postgres
end
