defmodule AllWarningsError.Repo do
  use Ecto.Repo,
    otp_app: :all_warnings_error,
    adapter: Ecto.Adapters.Postgres
end
