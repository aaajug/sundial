defmodule SundialWeb.TaskViewLive do
  use Phoenix.LiveView, layout: {SundialWeb.LayoutView, "live.html"}

  alias SundialWeb.TaskView
  alias Sundial.Tasks

  def render(assigns) do
    TaskView.render("index.html", assigns)
  end

  def mount(params, _session, socket) do
    sort_by = params["sort_by"]
    if Tasks.is_all_position_nil?(), do: Tasks.initialize_positions
    tasks = if sort_by == "default" do
              Tasks.list_tasks()
            else
              Tasks.list_tasks_by_position()
            end

    {:ok, assign(socket, %{tasks: tasks})}
  end

  def handle_info(msg, socket) do
    {:noreply, socket}
  end
end
