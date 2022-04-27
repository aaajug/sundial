defmodule Backend.TasksFixtures do
  alias Plug.Test
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        completed_on: ~N[2022-03-16 03:09:00],
        deadline: ~N[2022-03-16 03:09:00],
        description: "some description",
        details: "some details",
        list_id: 42,
        board_id: 5,
        position: 5000,
        status: 1
      })
      |> Backend.Tasks.create_task() # Need: (user, assignee, attrs, list_id, board_id)

    task
  end

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        content: "some content",
        task_id: 42,
        user_id: 42
      })
      |> Backend.Tasks.create_comment()

    comment
  end
end
