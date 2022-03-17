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
        completed_at: ~N[2022-03-16 03:09:00],
        deadline: ~N[2022-03-16 03:09:00],
        description: "some description",
        details: "some details",
        pane_id: 42
      })
      |> Sundial.Tasks.create_task()

    task
  end
end
