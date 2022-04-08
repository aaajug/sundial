defmodule Sundial.Lists.List do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lists" do
    field :board_id, :integer
    field :position, :integer
    field :title, :string
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:title, :user_id, :board_id, :position])
    |> validate_required([:title, :user_id, :board_id, :position])
  end
end
