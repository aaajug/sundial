defmodule Backend.BoardsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Boards` context.
  """

  @doc """
  Generate a board.
  """
  def board_fixture(attrs \\ %{}) do
    {:ok, board} =
      attrs
      |> Enum.into(%{

      })
      |> Backend.Boards.create_board()

    board
  end
end
