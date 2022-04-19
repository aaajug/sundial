defmodule Backend.Repo.Migrations.ListBelongsToBoard do
  use Ecto.Migration

  def change do
    alter table(:lists) do
      add :user_id, references(:users)
    end
  end
end
