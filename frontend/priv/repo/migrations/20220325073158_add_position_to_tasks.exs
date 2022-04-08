defmodule Sundial.Repo.Migrations.AddPositionToTasks do
  use Ecto.Migration

  def change do
    alter table("tasks") do
      add :position, :integer
    end
  end
end
