defmodule Cbtest.Repo do
  use Ecto.Repo,
    otp_app: :cbtest,
    adapter: Ecto.Adapters.SQLite3
end
