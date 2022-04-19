defmodule Backend.Repo.Migrations.RemoveColumnPaneIdFromTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      remove :pane_id
    end
  end
end
