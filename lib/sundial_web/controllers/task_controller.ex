defmodule SundialWeb.TaskController do
  use SundialWeb, :controller

  alias Sundial.Progress
  alias Sundial.Tasks
  alias Sundial.Tasks.Task
  alias Phoenix.LiveView


  def index(conn, _params) do
    # update task positions if needed, initially all tasks will have nil position, update them accordingly based on the default sorting
    if Tasks.is_all_position_nil?(), do: Tasks.initialize_positions # will only be executed once.
    # Handle: at least one task HAS a value position, other(s) are nil OR add position column on create by using row_num() see: https://elixirforum.com/t/how-to-get-a-row-by-id-with-row-number-in-ecto/24739/3    (adding position value on create preferred over handling it here)

    tasks = Tasks.list_tasks() # list_tasks (defualt sorting) if params[:sorting] == default (should be explicit), otherwise:
    # tasks = Tasks.list_tasks_by_position    # even if the user hasn't custom reordered their tasks, the tasks should be ordered by the default sorting since the initial positions are based on the default sorting. On the other hand, if the user already did custom reorder, the position column will be followed. The user can still view their tasks using the default sortiing but they won't be able to reorder through this view (set error message on move).

    # TODO: create flowchart for this sorting algo

    # IO.inspect "inspectdb: task pos"
    # tasks = Tasks.update_positions(tasks)
    tasks = Tasks.serialize(tasks)
    status = Progress.list_status()
    IO.inspect "in taskcontroller index"

    # render(conn, "index.html", tasks: tasks, status: status)
    # passing conn raises the error (ArgumentError) cannot deserialize #Function<0.16477574/1 in Plug.CSRFProtection.call
    # LiveView.Controller.live_render(conn, SundialWeb.TaskLiveView, session: %{"conn" => conn, "tasks" => tasks, "status" => status})
    LiveView.Controller.live_render(conn, SundialWeb.TaskViewLive, session: %{"tasks" => tasks, "status" => status})
  end

  def new(conn, _params) do
    status = Progress.list_status_options()
    changeset = Tasks.change_task(%Task{})
    render(conn, "new.html", status: status, changeset: changeset)
  end

  def create(conn, %{"task" => task_params}) do
    case Tasks.create_task(task_params) do
      {:ok, _task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: Routes.task_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    render(conn, "show.html", task: task)
  end

  def edit(conn, %{"id" => id}) do
    status = Progress.list_status_options()
    task = Tasks.get_task!(id)
    changeset = Tasks.change_task(task)
    task = Tasks.serialize(task)
    render(conn, "edit.html", status: status, task: task, changeset: changeset)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tasks.get_task!(id)

    # only do this when prompted from the tasks/index
    m = if (task_params["status"] == 4 || task_params["status"] == "4") && !Map.has_key?(task_params, "completed_on") do
      Map.put(task_params, "completed_on", NaiveDateTime.local_now)
    end

    task_params = m || task_params

    case Tasks.update_task(task, task_params) do
      {:ok, _task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        # |> redirect(to: Routes.task_path(conn, :index))
        LiveView.Controller.live_render(conn, SundialWeb.Live.Task.TaskComponent, session: %{"task" => task})

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    {:ok, _task} = Tasks.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: Routes.task_path(conn, :index))
  end
end
