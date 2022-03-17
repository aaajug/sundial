defmodule Sundial.Repo.Migrations.CreateLabels do
  use Ecto.Migration

  def change do
    create table(:labels) do
      add :name, :string
      add :color_class, :string

      timestamps()
    end
  end
end
