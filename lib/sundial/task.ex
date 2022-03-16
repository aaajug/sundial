defmodule Sundial.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :board_id, :integer
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
    |> cast(attrs, [:deadline, :details, :description, :completed_at, :pane_id, :board_id])
    |> validate_required([:deadline, :details, :description, :completed_at, :pane_id, :board_id])
  end
end
