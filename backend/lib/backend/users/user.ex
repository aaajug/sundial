defmodule Backend.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    pow_user_fields()

    field :first_name, :string
    field :last_name, :string

    has_many :authored_tasks, {"tasks", Backend.Tasks.Task}, foreign_key: :author_id
    has_many :assigned_tasks, {"tasks", Backend.Tasks.Task}, foreign_key: :assignee_id
    has_many :lists, Backend.Lists.List, foreign_key: :user_id
    has_many :boards, Backend.Boards.Board, foreign_key: :user_id
    has_many :permissions, Backend.Boards.Permission, foreign_key: :user_id
    many_to_many :shared_boards, {"boards", Backend.Boards.Board}, join_through: "permissions"

    timestamps()
  end
end
