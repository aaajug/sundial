defmodule Sundial.Repo.Migrations.CreateLabels do
  use Ecto.Migration

  def change do
    create table(:labels) do
      add :color, :string
      add :name, :string

      timestamps()
    end
  end
end
