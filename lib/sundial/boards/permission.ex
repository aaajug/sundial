defmodule Sundial.Boards.Permission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "permissions" do
    field :board_id, :integer
    field :delete, :boolean, default: false
    field :manage_users, :boolean, default: false
    field :read, :boolean, default: false
    field :user_id, :integer
    field :write, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(permission, attrs) do
    permission
    |> cast(attrs, [:user_id, :board_id, :write, :delete, :manage_users, :read])
    |> validate_required([:user_id, :board_id, :write, :delete, :manage_users, :read])
  end
end
