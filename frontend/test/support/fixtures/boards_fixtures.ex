defmodule Sundial.BoardsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sundial.Boards` context.
  """

  @doc """
  Generate a board.
  """
  def board_fixture(attrs \\ %{}) do
    {:ok, board} =
      attrs
      |> Enum.into(%{
        title: "some title",
        user_id: 42
      })
      |> Sundial.Boards.create_board()

    board
  end

  @doc """
  Generate a permission.
  """
  def permission_fixture(attrs \\ %{}) do
    {:ok, permission} =
      attrs
      |> Enum.into(%{
        board_id: 42,
        delete: true,
        manage_users: true,
        read: true,
        user_id: 42,
        write: true
      })
      |> Sundial.Boards.create_permission()

    permission
  end
end
