defmodule Backend.Boards.Board do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "boards" do


    timestamps()
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [])
    |> validate_required([])
  end
end
