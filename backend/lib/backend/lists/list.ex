defmodule Backend.Lists.List do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "lists" do


    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [])
    |> validate_required([])
  end
end
