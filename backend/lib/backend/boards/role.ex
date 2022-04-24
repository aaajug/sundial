defmodule Backend.Boards.Role do
  def get do
    [
      %{id: 1, name: "manager"},
      %{id: 2, name: "contributor"},
      %{id: 3, name: "member"}
    ]
  end

  def get_names do
    ["manager", "contributor", "member"]
  end
end
