defmodule Sundial.Pane do
  use Ecto.Schema
  import Ecto.Changeset

  schema "panes" do
    field :description, :string
    field :header, :string

    timestamps()
  end

  @doc false
  def changeset(pane, attrs) do
    pane
    |> cast(attrs, [:header, :description])
    |> validate_required([:header])
  end
end
