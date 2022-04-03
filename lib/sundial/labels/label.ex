defmodule Sundial.Labels.Label do
  use Ecto.Schema
  import Ecto.Changeset

  schema "labels" do
    field :color, :string, null: false, default: "#000000"
    field :name, :string, null: false, default: "new label"

    timestamps()
  end

  @doc false
  def changeset(label, attrs) do
    label
    |> cast(attrs, [:name, :color])
    |> validate_required([:name, :color])
  end
end
