defmodule Sundial.Repo.Migrations.CreatePanes do
  use Ecto.Migration

  def change do
    create table(:panes) do
      add :header, :string
      add :description, :text

      timestamps()
    end
  end
end
