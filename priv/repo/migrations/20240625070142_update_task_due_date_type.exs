defmodule PersonalPlanner.Repo.Migrations.UpdateTaskDueDateType do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      remove :due_date
      add :due_date, :date
    end
  end
end
