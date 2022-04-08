defmodule Sundial.Repo.Migrations.DropTableUsers do
  use Ecto.Migration

  def change do
    drop table(:users)
  end
end
