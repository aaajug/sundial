defmodule Backend.BoardsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Boards` context.
  """

  @doc """
  Generate a board.
  """
  def board_fixture(user_attrs \\ %{}, board_attrs \\ %{}) do
    user_attrs = user_attrs
      |> Enum.into(%{
        email: "alice@wonderland.com",
        password: "helloworld"
      })

      board_attrs = board_attrs
      |> Enum.into(%{
        title: "New board",
        user_id: 1
      })

    {:ok, board} =

      {:ok, user, _conn} = Pow.Plug.create_user(user_attrs)
      Backend.Boards.create_board(user, board_attrs, nil)

    board
  end
end
