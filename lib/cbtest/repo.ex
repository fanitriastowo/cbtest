defmodule Cbtest.Repo do
  use Ecto.Repo,
    otp_app: :cbtest,
    adapter: Ecto.Adapters.Postgres
end
