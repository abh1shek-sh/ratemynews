defmodule Ratemynews.Repo do
  use Ecto.Repo,
    otp_app: :ratemynews,
    adapter: Ecto.Adapters.Postgres
end
