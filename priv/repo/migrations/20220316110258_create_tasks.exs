defmodule Sundial.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :deadline, :naive_datetime
      add :details, :text
      add :description, :string, null: false, default: "Add a new task"
      add :completed_at, :naive_datetime
      add :pane_id, :integer, null: false, default: 0

      # TODO: implement association to boards once boards are implemented
      # add :board_id, :integer

      timestamps()
    end
  end
end
