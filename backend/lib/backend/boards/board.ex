defmodule Backend.Boards.Board do
  use Ecto.Schema
  import Ecto.Changeset

  # @primary_key {:id, :binary_id, autogenerate: true}
  # @foreign_key_type :binary_id

  schema "boards" do
    field :title, :string, null: false, default: "New Board"
    # field :user_id, :integer, default: 0

    belongs_to :user, Backend.Users.User
    has_many :lists, Backend.Lists.List, on_delete: :nilify_all
    has_many :tasks, Backend.Tasks.Task, on_delete: :nilify_all
    has_many :permissions, Backend.Boards.Permission, foreign_key: :board_id, on_delete: :nilify_all
    many_to_many :users, Backend.Users.User, join_through: "permissions", on_delete: :nothing

    timestamps()
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:title, :user_id])
    |> validate_required([:title])
  end

  def insert_changeset(board, attrs) do
    board
    |> cast(attrs, [:title, :user_id])
    |> validate_required([:title, :user_id])
  end
end
