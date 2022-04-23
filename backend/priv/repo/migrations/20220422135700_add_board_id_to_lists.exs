defmodule Backend.Repo.Migrations.AddBoardIdToLists do
  use Ecto.Migration

  def change do
    alter table(:lists) do
      add :board_id, references(:boards)
    end
  end
end
