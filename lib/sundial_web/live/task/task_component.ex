defmodule SundialWeb.Live.Task.TaskComponent do
  use Phoenix.LiveComponent

  import SundialWeb.TaskLive.Sections

  alias Sundial.Progress.States
  alias Sundial.Tasks

  def mount(socket) do
    {:ok, assign(socket, %{status: States.get()})}
  end

  def preload(list_of_assigns) do
    if Tasks.is_all_position_nil?(), do: Tasks.initialize_positions # or create a migration to update all existing records?

    task_ids = Enum.map(list_of_assigns, & &1.id)

    tasks = Tasks.list_tasks(task_ids)
    tasks = Tasks.serialize(tasks)

    Enum.map(list_of_assigns, fn(assigns) ->
      task = Enum.find(tasks, fn(task) -> assigns.id == task.id end)
      Map.merge(assigns, %{task: task})
     end)
  end

  def update(assigns, socket) do
    {:ok,
      socket
      |> assign(assigns)}
  end

  def handle_event("update_status", params, socket) do
    task = Tasks.get_task!(socket.assigns.task.id)

    task_params = %{}
    task_params = Map.put(task_params, "status", params["status"])
    task_params = Map.put(task_params, "completed_on", NaiveDateTime.local_now)

    case Tasks.update_task(task, task_params) do
      {:ok, _task} ->
        {:reply, socket, push_redirect(socket, to: params["return_to"])}

      {:error, %Ecto.Changeset{} = _changeset} ->
        put_flash(socket, :error, "Can't update status as of the moment. Please try again later.")
    end
  end

  # No longer used -- replaced by the drag&drop functionality
  def handle_event("update_position", params, socket) do
    task = Tasks.get_task!(socket.assigns.task.id)
    index = params["index"] |> String.to_integer()
    moves = if params["down"], do: params["down"] |> String.to_integer, else: -(params["up"] |> String.to_integer)

    case Tasks.find_insert_position(task, index, moves) do
      {:ok, _} ->
        # {:reply, socket, push_redirect(socket, to: "/")}
        # {:reply, socket, "Success"}
        {:noreply, socket}
      {:error, _} ->
        put_flash(socket, :error, "Can't reorder tasks as of the moment. Please try again later.")
    end
  end

  def handle_event("dropped", %{"list" => list}, socket) do
    case Tasks.update_positions(list) do
      {:ok, _} ->
        {:reply, socket, push_redirect(socket, to: "/")}
      {:error, _} ->
        put_flash(socket, :error, "Can't reorder tasks as of the moment. Please try again later.")
    end
  end

  def handle_event("delete", %{"id" => id, "return_to" => return_to}, socket) do
    task = Tasks.get_task!(id)
    {:ok, _} = Tasks.delete_task(task)

    IO.inspect "debug:"
    IO.inspect return_to

    # {:noreply, assign(socket, :tasks, list_tasks())}
    {:noreply,
     socket
       |> put_flash(:info, "Task successfully deleted.")
       |> push_redirect(to: return_to)}
  end
end
