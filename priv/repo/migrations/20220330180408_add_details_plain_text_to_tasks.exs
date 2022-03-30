defmodule Sundial.Repo.Migrations.AddDetailsPlainTextToTasks do
  use Ecto.Migration

  def change do
    alter table("tasks") do
      add :details_plaintext, :text
    end
  end
end
