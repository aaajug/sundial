defmodule Backend.Tasks.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :content, :string
    # field :task_id, :integer
    # field :user_id, :integer

    belongs_to :task, Backend.Tasks.Task
    belongs_to :user, Backend.Users.User

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :user_id, :task_id])
    |> validate_required([:content])
  end
end
