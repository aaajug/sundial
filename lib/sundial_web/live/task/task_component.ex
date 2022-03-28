defmodule SundialWeb.Live.Task.TaskComponent do
  use Phoenix.LiveComponent

  alias SundialWeb.TaskView
  alias Sundial.Progress.States
  alias Sundial.Tasks

  def render(assigns) do
    TaskView.render("show.html", assigns)
  end

  def mount(_params, _session, socket) do
    # IO.inspect("inspectdb: in mount/3 of taskcomponent")
    {:ok, assign(socket, %{status: States.get()})}
  end

  def mount(_session, socket) do
    # IO.inspect("inspectdb: in mount/2 of taskcomponent")
    {:ok, assign(socket, %{status: States.get()})}
  end

  def mount(socket) do
    # IO.inspect("inspectdb: in mount/1 of taskcomponent")
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
    # IO.inspect "in task component update"
    {:ok,
      socket
      |> assign(assigns)}
  end

  # Listen for status change from TaskComponent (index view)
  def handle_event("update_status", task_params, socket) do
    # IO.inspect status_id %{"status" => status_id}
    task = Tasks.get_task!(socket.assigns.task.id)

    Map.put(task_params, "completed_on", NaiveDateTime.local_now)

    case Tasks.update_task(task, task_params) do
      {:ok, _task} ->
        # {:noreply, assign(socket, %{task: Tasks.serialize_task(task)})}
        # send_update(pid \\ self(), module, assigns)
        # redirect(socket, arg2)
        # socket = put_flash(socket, :info, "Status updated!")
        # {:ok, assign(socket, %{new: "new"})}
        {:reply, socket, push_redirect(socket, to: "/")}

      {:error, %Ecto.Changeset{} = _changeset} ->
        put_flash(socket, :error, "Can't update status as of the moment. Please try again later.")
    end

    # {:noreply, socket}
    # {:reply, map, %Socket}
  end

  # task_params: %{"before" => before, "after" => after}
  def handle_event("update_position", params, socket) do
    task = Tasks.get_task!(socket.assigns.task.id)
    index = params["index"] |> String.to_integer()

    # before -- position of the element before self, after -- position of the element after self
    # IO.puts "in task component update position"

    # assign moves
    moves = if params["down"], do: params["down"] |> String.to_integer, else: -(params["up"] |> String.to_integer)

    case Tasks.find_insert_position(task, index, moves) do
      {:ok, _} ->
        IO.inspect "Task reordered"
        {:reply, socket, push_redirect(socket, to: "/")}
      {:error, _} ->
        put_flash(socket, :error, "Can't reorder status as of the moment. Please try again later.")
    end
  end
end
