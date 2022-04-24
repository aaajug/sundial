defmodule Backend.Repo.Migrations.CreatePermissions do
  use Ecto.Migration

  def change do
    create table(:permissions) do
      add :board_id, references(:boards)
      add :user_id, references(:users)
      add :role, :string

      timestamps()
    end

    create unique_index(:permissions, [:board_id, :user_id])
  end
end
