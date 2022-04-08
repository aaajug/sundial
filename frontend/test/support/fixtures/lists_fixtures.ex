defmodule Sundial.ListsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sundial.Lists` context.
  """

  @doc """
  Generate a list.
  """
  def list_fixture(attrs \\ %{}) do
    {:ok, list} =
      attrs
      |> Enum.into(%{
        board_id: 42,
        position: 42,
        title: "some title",
        user_id: 42
      })
      |> Sundial.Lists.create_list()

    list
  end
end
