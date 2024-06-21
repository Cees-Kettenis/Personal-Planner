defmodule PersonalPlanner.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :number, :string, null: false
      add :title, :string, null: false
      add :description, :string, null: false
      add :sequence, :integer, null: false
      add :task_type, :integer, null: false
      add :due_date, :utc_datetime, null: false
      add :creator_id, references(:users, on_delete: :nilify_all), null: false

      add :assigned_to_id, references(:users, on_delete: :nilify_all)
      add :started_at, :utc_datetime, default: nil
      add :completed_at, :utc_datetime, default: nil
      add :week, :integer, default: nil
      add :year, :integer, default: nil
      add :parent_task_number, :string
      add :root_task_number, :string

      timestamps(type: :utc_datetime)
    end

    create index(:tasks, [:week, :year, :number, :sequence, :due_date])
  end
end
