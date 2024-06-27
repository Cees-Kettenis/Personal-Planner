defmodule PersonalPlanner.Repo.Migrations.AddImageBinary do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :image, :binary
    end
  end
end
