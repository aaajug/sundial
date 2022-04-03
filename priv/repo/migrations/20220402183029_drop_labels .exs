defmodule Sundial.Repo.Migrations.DropLabels do
  use Ecto.Migration

  def up do
    drop table("labels");
  end
end
