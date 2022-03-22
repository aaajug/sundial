defmodule SundialWeb.TaskController do
  use SundialWeb, :controller

  alias Sundial.Progress
  alias Sundial.Tasks
  alias Sundial.Tasks.Task

  def index(conn, _params) do
    tasks = Tasks.list_tasks()
    tasks = Tasks.serialize(tasks)
    status = Progress.list_status()

    render(conn, "index.html", tasks: tasks, status: status)
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

    m = if task_params["status"] == 4 || task_params["status"] == "4" do
      Map.put(task_params, "completed_on", NaiveDateTime.local_now)
    end

    task_params = m || task_params

    case Tasks.update_task(task, task_params) do
      {:ok, _task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: Routes.task_path(conn, :index))

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
