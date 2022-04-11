defmodule Backend.Repo.Migrations.AddColumnsToTasks do
  use Ecto.Migration

  def change do
    alter table("tasks") do
      add :list_id, :integer
      add :creator_id, :integer
      add :user_id, :integer
    end
  end
end
