defmodule Backend.Progress.Status do
  use Ecto.Schema
  import Ecto.Changeset

  schema "status" do
    field :description, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(status, attrs) do
    status
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
