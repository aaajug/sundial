defmodule Backend.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :title, :string
      add :position, :integer

      timestamps()
    end
  end
end
