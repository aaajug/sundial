defmodule Backend.Repo.Migrations.DropTableUserTokens do
  use Ecto.Migration

  def change do
    drop table(:users_tokens)
  end
end
