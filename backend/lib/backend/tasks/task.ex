defmodule Backend.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :description, :string, null: false, default: "New task"
    field :details, :string
    field :details_plaintext, :string
    field :deadline, :naive_datetime, default: nil
    field :status, :integer, default: 1
    field :completed_on, :naive_datetime, default: nil
    field :position, :integer
    # field :list_id, :integer, null: false, default: 0
    # field :board_id, :integer, null: false, default: 0

    belongs_to :list, Backend.Lists.List
    belongs_to :board, Backend.Boards.Board
    belongs_to :assignee,  {"assignee", Backend.Users.User}
    belongs_to :author, {"author", Backend.Users.User}
    has_many :comments, Backend.Tasks.Comment

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:description, :details, :details_plaintext, :deadline, :status, :completed_on, :list_id, :board_id, :position])
    |> validate_required([:description])
  end
end
