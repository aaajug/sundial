defmodule BackendWeb.TaskController do
  use BackendWeb, :controller

  alias Backend.Progress
  alias Backend.Tasks
  alias Backend.Tasks.Task

  def changeset(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    changeset = Tasks.change_task(task)

    text(conn, "Changeset")
    # json conn, changeset
  end

  def show(conn, %{"id" => id}) do
    serialized_task =
      Tasks.get_task!(id)
        |> Tasks.serialize

    json conn, serialized_task
  end

  def new do
    status = list_status_options
    changeset = Tasks.change_task(%Task{})
    serial_task = nil
  end

  def create(conn, %{"board_id" => board_id, "list_id" => list_id, "data" => task_params})do
  # def create(conn, _params)do
    # text(conn, "Posted create task")
    task_params = for {key, val} <- task_params, into: %{}, do: {String.to_atom(key), val}
    user = Pow.Plug.current_user(conn)

    case Tasks.create_task(user, task_params, list_id, board_id) do
            {:ok, task} ->
              data = Tasks.serialize(task)
              # Jason.encode(data)
              json conn, data
              # conn
              #   |> text(Jason.encode(task))
              # |> put_flash(:info, "Task created successfully.")


            {:error, %Ecto.Changeset{} = changeset} ->
              # Jason.encode("error creating task")
              text(conn, "error creating task")
              # render(conn, "new.html", changeset: changeset)
          end
  end

  # %{"id" => id, "data" => task_params}
  def update(conn, params) do
    id = String.to_integer(params["id"])
    task = Tasks.get_task!(id)

    task_params = Map.delete(params, "id")

    case Tasks.update_task(task, task_params) do
            {:ok, _task} ->
              data = Tasks.serialize(Tasks.get_task!(id))
              json conn, data

            {:error, %Ecto.Changeset{} = changeset} ->
              text(conn, "error updating task")
    end
  end

  # def list_tasks(conn, params) do

  #   list_tasks(conn)
  # end

  def list_tasks(conn, params) do
    tasks = get_tasks(params)

    serialized_tasks = Tasks.serialize(tasks)

    IO.inspect "boardsdb5"
    IO.inspect serialized_tasks

    json conn, serialized_tasks
  end

  def list_tasks_by_default(conn, _params) do
    tasks = Tasks.list_tasks
    # IO.inspect "db tasks:"
    # IO.inspect tasks
    serialized_tasks = Tasks.serialize(tasks)

    # IO.inspect "serialized tasks"
    # IO.inspect serialized_tasks

    # data = Enum.map(serialized_tasks, fn task -> task |> Jason.encode end)

    # IO.inspect "data"
    # IO.inspect data

    # res = %{data: data}
    # res = Jason.encode(data)
    # res = Jason.encode!(%{"age" => 44, "name" => "Steve Irwin", "nationality" => "Australian"})
    # "{\"age\":44,\"name\":\"Steve Irwin\",\"nationality\":\"Australian\"}"
    json conn, serialized_tasks
  end

  def list_status_options do
    Progress.list_status_options()
  end

  def update_positions(conn, %{"list" => list}) do
    list = list
      # |> String.split("[")
      # |> Enum.join
      # |> String.split("]")
      # |> Enum.join
      # |> String.split(",")
      |> Enum.map(fn id -> String.to_integer(id) end)

    case Tasks.update_positions(list) do
      {:ok, _, _} ->
        # {:reply, socket, push_redirect(socket, to: "/")}
        text(conn, "tasks reordered")
      {:error, _} ->
        text(conn, "error updating task")
        # put_flash(socket, :error, "Can't reorder tasks as of the moment. Please try again later.")
        # {:reply, socket, push_redirect(socket, to: "/")}
    end
  end

  def update_status(conn, params) do
    id = String.to_integer(params["id"])
    task = Tasks.get_task!(id)

    task_params = %{}
    task_params = Map.put(task_params, "status", String.to_integer(params["status"]))
    task_params = Map.put(task_params, "completed_on", NaiveDateTime.local_now)

    case Tasks.update_task(task, task_params) do
      {:ok, _task} ->
        data = Tasks.serialize(Tasks.get_task!(id))
        json conn, data

      {:error, %Ecto.Changeset{} = _changeset} ->
        text(conn, "Unable to update task")
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    {:ok, _task} = Tasks.delete_task(task)

    text(conn, "Task deleted successfully")
    # conn
    #   |> put_flash(:info, "Task deleted successfully.")
    #   |> redirect(to: Routes.task_path(conn, :index))
  end

  defp get_tasks(params) do
    if Map.has_key?(params, "ids") && params["ids"] != "" do
      ids = params["ids"]
            |> String.split(",")
            |> Enum.map(
                fn id ->
                  String.to_integer(id)
                end
            )

      Tasks.list_tasks(ids)
    else
      Tasks.list_tasks_by_position
    end
  end
end
