defmodule Backend.ListsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Lists` context.
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
      |> Backend.Lists.create_list()

    list
  end
end
