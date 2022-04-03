defmodule Sundial.LabelsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sundial.Labels` context.
  """

  @doc """
  Generate a label.
  """
  def label_fixture(attrs \\ %{}) do
    {:ok, label} =
      attrs
      |> Enum.into(%{
        color_class: "some color_class",
        name: "some name"
      })
      |> Sundial.Labels.create_label()

    label
  end

  @doc """
  Generate a label.
  """
  def label_fixture(attrs \\ %{}) do
    {:ok, label} =
      attrs
      |> Enum.into(%{
        color: "some color",
        name: "some name"
      })
      |> Sundial.Labels.create_label()

    label
  end
end
