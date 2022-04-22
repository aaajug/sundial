defmodule Backend.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    pow_user_fields()

    field :first_name, :string
    field :last_name, :string

    has_many :authored_tasks, {"tasks", Backend.Tasks.Task}, foreign_key: :author_id
    has_many :assigned_tasks, {"tasks", Backend.Tasks.Task}, foreign_key: :assignee_id
    has_many :lists, Backend.Lists.List
    has_many :boards, Backend.Boards.Board

    timestamps()
  end
end
