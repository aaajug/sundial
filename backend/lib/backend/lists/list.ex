defmodule Backend.Lists.List do
  use Ecto.Schema
  import Ecto.Changeset

  # @primary_key {:id, :binary_id, autogenerate: true}
  # @foreign_key_type :binary_id
  schema "lists" do
    field :title, :string, null: false, default: "Unnamed list"
    # field :user_id, :integer, default: 0
    # field :board_id, :integer, default: 0
    field :position, :integer, default: 0

    belongs_to :user, Backend.Users.User
    belongs_to :board, Backend.Boards.Board
    has_many :tasks, Backend.Tasks.Task

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:title, :user_id, :board_id, :position])
    |> validate_required([:title])
  end
end
