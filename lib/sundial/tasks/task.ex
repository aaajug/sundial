defmodule Sundial.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :completed_at, :naive_datetime
    field :deadline, :naive_datetime
    field :description, :string
    field :details, :string
    field :pane_id, :integer

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:completed_at, :deadline, :description, :details, :pane_id])
    |> validate_required([:description])
  end
end
