defmodule Sundial.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :deadline, :naive_datetime
      add :details, :text
      add :description, :string
      add :completed_at, :naive_datetime
      add :pane_id, :integer
      add :board_id, :integer

      timestamps()
    end
  end
end
