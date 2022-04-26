defmodule BackendWeb.CommentController do
  use BackendWeb, :controller

  alias Backend.Progress
  alias Backend.Tasks
  alias Backend.Users
  alias Backend.Tasks.Task
  alias Backend.Tasks.Comment

  plug BackendWeb.Authorize, resource: Comment

  def show(conn, %{"id" => id}) do
    serialized_task =
      Tasks.get_task!(id)
        |> Tasks.serialize

    json conn, serialized_task
  end

  def create(conn, %{"id" => task_id, "data" => comment_params})do
    user = Pow.Plug.current_user(conn)

    case Tasks.create_comment(user, task_id, comment_params) do
            {:ok, comment} ->
              data = Tasks.serialize_task_comment(comment)
              json conn, data

            {:error, %Ecto.Changeset{} = changeset} ->
              text(conn, "error creating task")
          end
  end

  def update(conn, %{"task_id" => task_id, "comment_id" => comment_id, "data" => comment_params}) do
    task = Tasks.get_task!(task_id)
    user = Pow.Plug.current_user(conn)
    comment = Tasks.get_comment!(comment_id)

        case Tasks.update_comment(task, user, comment, comment_params) do
                {:ok, comment} ->
                  # IO.inspect "okupdatedtask"
                  data = Tasks.serialize_comment(comment)
                  json conn, data

                {:error, %Ecto.Changeset{} = changeset} ->
                  text(conn, "error updating task")
        end
  end

  def delete(conn, %{"id" => id}) do
    comment = Tasks.get_comment!(id)
    {:ok, _comment} = Tasks.delete_comment(comment)

    text(conn, "Comment deleted successfully.")
  end
end
