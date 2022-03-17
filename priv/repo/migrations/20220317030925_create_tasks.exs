defmodule Sundial.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :completed_at, :naive_datetime
      add :deadline, :naive_datetime
      add :description, :string
      add :details, :text
      add :pane_id, :integer

      timestamps()
    end
  end
end
