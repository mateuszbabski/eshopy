defmodule Eshopy.Repo do
  use Ecto.Repo,
    otp_app: :eshopy,
    adapter: Ecto.Adapters.Postgres
end
