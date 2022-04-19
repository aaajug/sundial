defmodule Backend.Repo.Migrations.AddBoardIdToTasks do
  use Ecto.Migration

  def change do
    alter table("tasks") do
      add :board_id, :integer
    end
  end
end
