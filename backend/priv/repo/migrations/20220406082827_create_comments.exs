defmodule Backend.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :text
      add :task_id, references(:tasks)

      timestamps()
    end
  end
end
