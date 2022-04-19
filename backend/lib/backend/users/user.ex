defmodule Backend.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    pow_user_fields()

    has_many :authored_tasks, {"authored_tasks", Backend.Tasks.Task}, foreign_key: :author_id
    has_many :assigned_tasks, {"assigned_tasks", Backend.Tasks.Task}, foreign_key: :assignee_id
    has_many :lists, Backend.Lists.List
    has_many :boards, Backend.Boards.Board

    timestamps()
  end
end
