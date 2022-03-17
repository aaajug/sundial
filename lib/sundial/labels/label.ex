defmodule Sundial.Labels.Label do
  use Ecto.Schema
  import Ecto.Changeset

  schema "labels" do
    field :color_class, :string, null: false, default: "yellow-buff"
    field :name, :string, null: false, default: "new label"

    timestamps()
  end

  @doc false
  def changeset(label, attrs) do
    label
    |> cast(attrs, [:name, :color_class])
    |> validate_required([:name, :color_class])
  end
end
