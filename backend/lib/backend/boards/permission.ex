defmodule Backend.Boards.Permission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "permissions" do
    # field :board_id, :integer
    # field :user_id, :integer
    field :role, :string

    belongs_to :user, Backend.Users.User
    belongs_to :board, Backend.Boards.Board

    timestamps()
  end

  @doc false
  def changeset(permission, attrs) do
    permission
    |> cast(attrs, [:user_id, :board_id, :role])
    |> validate_required([:user_id, :board_id, :role])
    |> unique_constraint([:user_id, :board_id])
  end
end
