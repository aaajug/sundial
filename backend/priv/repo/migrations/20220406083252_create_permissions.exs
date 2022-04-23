defmodule Backend.Repo.Migrations.CreatePermissions do
  use Ecto.Migration

  def change do
    create table(:permissions) do
      add :board_id, references(:boards)

      timestamps()
    end
  end
end
