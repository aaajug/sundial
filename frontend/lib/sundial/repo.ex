defmodule Sundial.Repo do
  use Ecto.Repo,
    otp_app: :sundial,
    adapter: Ecto.Adapters.Postgres
end
