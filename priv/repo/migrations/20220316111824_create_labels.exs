defmodule Sundial.Repo.Migrations.CreateLabels do
  use Ecto.Migration

  def change do
    create table(:labels) do
      add :name, :string, null: false, default: "label"
      add :color_class, :string, null: false, default: "yellow-buff"

      timestamps()
    end
  end
end
