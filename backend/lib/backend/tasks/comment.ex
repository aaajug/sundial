defmodule Backend.Tasks.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :content, :string
    field :task_id, :integer
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :user_id, :task_id])
    |> validate_required([:content, :user_id, :task_id])
  end
end
