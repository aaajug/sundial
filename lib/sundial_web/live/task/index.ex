defmodule SundialWeb.TaskLive.Index do
  use SundialWeb, :live_view

  alias Sundial.Tasks
  alias Sundial.Tasks.Task
  alias Sundial.Progress

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :tasks, list_tasks())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Add task")
    |> assign(:status, Progress.list_status_options())
    |> assign(:task, %Task{})
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    task = Tasks.get_task!(id)

    socket
    |> assign(:page_title, "Edit Task")
    |> assign(:status, Progress.list_status_options())
    |> assign(:task, task)
    |> assign(:serial_task, Tasks.serialize(task))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:user, nil)
  end

  defp list_tasks do
    Tasks.list_tasks_by_position()
  end
end
