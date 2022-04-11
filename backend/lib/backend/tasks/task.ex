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
    field :pane_id, :integer, null: false, default: 0
    field :position, :integer

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:description, :details, :details_plaintext, :deadline, :status, :completed_on, :pane_id, :position])
    |> validate_required([:description])
  end
end
