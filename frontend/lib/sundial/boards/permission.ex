defmodule Sundial.Boards.Permission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "permissions" do
    field :board_id, :integer
    field :user_id, :integer
    field :role, :string

    timestamps()
  end

  @doc false
  def changeset(permission, attrs) do
    permission
    |> cast(attrs, [:user_id, :board_id, :write, :delete, :manage_users, :read])
    |> validate_required([:write, :delete, :manage_users, :read])
  end
end
