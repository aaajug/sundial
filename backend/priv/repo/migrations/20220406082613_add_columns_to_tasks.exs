defmodule Backend.Repo.Migrations.AddColumnsToTasks do
  use Ecto.Migration

  def change do
    alter table("tasks") do
      add :list_id, references(:lists)
      add :board_id, references(:boards)
    end
  end
end
