defmodule Backend.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :text
      add :user_id, :integer
      add :task_id, :integer

      timestamps()
    end
  end
end
