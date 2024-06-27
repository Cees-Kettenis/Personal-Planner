defmodule PersonalPlanner.Repo.Migrations.AddUserImage do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :image_url, :string, default: ""
    end
  end
end
