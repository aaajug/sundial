defmodule Backend.Progress.States do
  def get do
    [
      %{id: 1, name: "initial", description: "Not yet started"},
      %{id: 2, name: "started", description: "In progress"},
      %{id: 3, name: "paused", description: "On hold"},
      %{id: 4, name: "completed", description: "Completed"}
    ]
  end
end
