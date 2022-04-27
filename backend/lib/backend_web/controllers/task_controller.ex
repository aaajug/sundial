defmodule BackendWeb.TaskController do
  use BackendWeb, :controller

  alias Backend.Progress
  alias Backend.Tasks
  alias Backend.Users
  alias Backend.Tasks.Task

  plug BackendWeb.Authorize, resource: Task

  def get_role(conn, %{"board_id" => board_id}) do
    role = Users.get_role(Pow.Plug.current_user(conn), board_id)
    text conn, role
  end

  def show(conn, %{"id" => id}) do
    user = Pow.Plug.current_user(conn)
    serialized_task = Tasks.serialize(user, Tasks.get_task!(id))

    json conn, %{data: serialized_task}
  end

  def create(conn, %{"board_id" => board_id, "list_id" => list_id, "data" => task_params})do
    user = Pow.Plug.current_user(conn)
    assignee = get_assignee(task_params, user)

    case Tasks.create_task(user, assignee, task_params, list_id, board_id) do
            {:ok, task} ->
              data = Tasks.serialize(user, task)
              json conn, data

            {:error, %Ecto.Changeset{} = changeset} ->
              text(conn, "error creating task")
          end
  end

  def update(conn, params) do
    id = String.to_integer(params["id"])
    task = Tasks.get_task!(id)

    user = Pow.Plug.current_user(conn)
    assignee = get_assignee(params, user)

    cond do
      assignee == :error -> json conn, %{error: %{errors: %{assignee: ["doesn't exist"]}}}
      true ->
        task_params = Map.delete(params, "id")

        case Tasks.update_task(task, assignee, task_params) do
                {:ok, task} ->
                  data = Tasks.serialize(user, task)
                  json conn, data

                {:error, %Ecto.Changeset{} = changeset} ->
                  text(conn, "error updating task")
        end
    end
  end

  def list_tasks(conn, params) do
    tasks = get_tasks(params)
    user = Pow.Plug.current_user(conn)

    serialized_tasks = Tasks.serialize(user, tasks)

    IO.inspect "boardsdb5"
    IO.inspect serialized_tasks

    json conn, serialized_tasks
  end

  def list_status_options do
    Progress.list_status_options()
  end

  def update_positions(conn, %{"insert_index" => insert_index, "list_id" => list_id, "task_id" => task_id}) do
    user = Pow.Plug.current_user(conn)

    case Tasks.update_positions(user, insert_index, list_id, task_id) do
      {:ok, response} ->
        json conn, response

      {:error, message} ->
        text(conn, %{error: message})
    end
  end

  def update_status(conn, params) do
    user = Pow.Plug.current_user(conn)

    id = String.to_integer(params["id"])
    task = Tasks.get_task!(id)

    task_params = %{}
    task_params = Map.put(task_params, "status", String.to_integer(params["status"]))
    task_params = Map.put(task_params, "completed_on", NaiveDateTime.local_now)

    case Tasks.update_task(task, nil, task_params) do
      {:ok, _task} ->
        data = Tasks.serialize(user, Tasks.get_task!(id))
        json conn, data

      {:error, %Ecto.Changeset{} = _changeset} ->
        text(conn, "Unable to update task")
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    {:ok, _task} = Tasks.delete_task(task)

    text(conn, "Task deleted successfully")
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

  defp get_assignee(params, user) do
    if Map.has_key?(params, "assignee") do
      if params["assignee"] == "" || params["assignee"] == nil do
        nil
      else
        assignee_param = params["assignee"]
        assigned_user = if String.trim(assignee_param) == "myself" do
                          user
                         else
                          Users.get_user_by_email(assignee_param)
                         end

        if assigned_user do
          assigned_user
        else
          :error
        end
      end
    else
      nil
    end
  end
end
