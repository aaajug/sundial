defmodule Backend.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  # @primary_key {:id, :binary_id, autogenerate: true}
  # @foreign_key_type :binary_id
  schema "users" do
    has_many :authored_tasks, {"authored_tasks", Backend.Tasks.Task}, foreign_key: :author_id
    has_many :assigned_tasks, {"assigned_tasks", Backend.Tasks.Task}, foreign_key: :assignee_id
    has_many :lists, Backend.Lists.List
    has_many :boards, Backend.Boards.Board

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [])
    |> validate_required([])
  end
end
