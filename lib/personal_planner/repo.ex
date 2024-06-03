defmodule PersonalPlanner.Repo do
  use Ecto.Repo,
    otp_app: :personal_planner,
    adapter: Ecto.Adapters.Postgres
end
