defmodule Backend.Repo.Migrations.CreateBoards do
  use Ecto.Migration

  def change do
    create table(:boards) do
      add :title, :string
      add :user_id, :integer

      timestamps()
    end
  end
end
