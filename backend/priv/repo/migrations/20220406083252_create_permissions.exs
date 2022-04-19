defmodule Backend.Repo.Migrations.CreatePermissions do
  use Ecto.Migration

  def change do
    create table(:permissions) do
      add :board_id, references(:boards)
      add :write, :boolean, default: false, null: false
      add :delete, :boolean, default: false, null: false
      add :manage_users, :boolean, default: false, null: false
      add :read, :boolean, default: false, null: false

      timestamps()
    end
  end
end
