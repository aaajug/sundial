defmodule SundialWeb.TaskLive.Index do
  use SundialWeb, :live_view

  alias Sundial.Tasks
  alias Sundial.Tasks.Task
  alias Sundial.Progress

  @impl true
  def mount(params, _session, socket) do
    sort = if Map.has_key?(params, "sort"), do: params["sort"], else: nil

    socket = case sort do
      "default" ->
        socket
          |> assign(:sort_class, "is-warning is-active is-focused")
          |> assign(:sort_target, "/")
          |> assign(:return_target, "/?sort=default")
          |> assign(:drag_hook, "None")
          |> assign(:sort_label, "Disable")
          |> assign(:tasks, list_tasks_by_default())

      _ ->
        socket
          |> assign(:sort_class, "sort-custom-button")
          |> assign(:sort_target, "/?sort=default")
          |> assign(:return_target, "/")
          |> assign(:drag_hook, "Drag")
          |> assign(:sort_label, "Enable")
          |> assign(:tasks, list_tasks())
    end

    {:ok, socket}
  end

  @impl true
  def handle_event("toggle-sorting", %{"sort_target" => sort_target}, socket) do
    {:reply, socket, push_redirect(socket, to: sort_target)}
  end

  @impl true
  def handle_event("add-task", _params, socket) do
    {:reply, socket, push_redirect(socket, to: "/tasks/new")}
  end

  @impl true
  def handle_event("dropped", %{"list" => list}, socket) do
    case Tasks.update_positions(list) do
      {:ok, _, _} ->
        {:reply, socket, push_redirect(socket, to: "/")}
      {:error, _} ->
        put_flash(socket, :error, "Can't reorder tasks as of the moment. Please try again later.")
        {:reply, socket, push_redirect(socket, to: "/")}
    end
  end

  @impl true
  def handle_event("move_column", _params, socket) do
    socket = put_flash(socket, :error, "Dropping to another column not allowed. Please use the status buttons on the left side of each task card.")
    {:reply, socket, push_redirect(socket, to: "/")}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Add a new task")
    |> assign(:status, Progress.list_status_options())
    |> assign(:task, %Task{})
    |> assign(:serial_task, nil)
  end

  defp apply_action(socket, :edit, %{"id" => id, "return_to" => return_to}) do
    task = Tasks.get_task!(id)

    socket
    |> assign(:page_title, "Edit Task")
    |> assign(:status, Progress.list_status_options())
    |> assign(:task, task)
    |> assign(:serial_task, Tasks.serialize(task))
    |> assign(:return_to, return_to)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:task, nil)
  end

  defp list_tasks do
    Tasks.list_tasks_by_position
  end

  defp list_tasks_by_default do
    Tasks.list_tasks
  end
end
