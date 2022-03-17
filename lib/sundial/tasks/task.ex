defmodule Sundial.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :completed_on, :naive_datetime, default: nil
    field :deadline, :naive_datetime, default: nil
    field :description, :string, null: false, default: "New task"
    field :details, :string
    field :pane_id, :integer, null: false, default: 0

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:completed_on, :deadline, :description, :details, :pane_id])
    |> validate_required([:description])
  end
end
