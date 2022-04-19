defmodule Backend.Boards.Board do
  use Ecto.Schema
  import Ecto.Changeset

  # @primary_key {:id, :binary_id, autogenerate: true}
  # @foreign_key_type :binary_id

  schema "boards" do
    field :title, :string, null: false, default: "New Board"
    # field :user_id, :integer, default: 0

    belongs_to :user, Backend.Users.User
    has_many :lists, Backend.Lists.List
    has_many :tasks, Backend.Tasks.Task

    timestamps()
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:title, :user_id])
    |> validate_required([:title, :user_id])
  end
end
