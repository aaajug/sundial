defmodule Sundial.ProgressFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sundial.Progress` context.
  """

  @doc """
  Generate a status.
  """
  def status_fixture(attrs \\ %{}) do
    {:ok, status} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Sundial.Progress.create_status()

    status
  end
end
