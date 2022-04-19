defmodule Backend.Repo.Migrations.AddUserIdToBoards do
  use Ecto.Migration

  def change do
    alter table(:boards) do
      add :user_id, references(:users)
    end
  end
end
