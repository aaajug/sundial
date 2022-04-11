defmodule Backend.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :title, :string
      add :user_id, :integer
      add :board_id, :integer
      add :position, :integer

      timestamps()
    end
  end
end
