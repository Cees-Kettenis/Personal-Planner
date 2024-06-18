defmodule PersonalPlanner.Repo.Migrations.AddActivationToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :activated, :boolean, null: false, default: false
      add :activated_at, :utc_datetime
    end
  end
end
