defmodule Backend.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :description, :string
      add :details, :text
      add :deadline, :naive_datetime
      add :status, :integer
      add :completed_on, :naive_datetime
      add :pane_id, :integer

      timestamps()
    end
  end
end
