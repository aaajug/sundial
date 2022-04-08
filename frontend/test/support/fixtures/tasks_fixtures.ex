defmodule Sundial.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sundial.Tasks` context.
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
        pane_id: 42,
        position: 0,
        status: 1
      })
      |> Sundial.Tasks.create_task()

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
      |> Sundial.Tasks.create_comment()

    comment
  end
end
