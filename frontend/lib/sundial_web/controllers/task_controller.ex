defmodule SundialWeb.TaskController do
  use SundialWeb, :controller

  alias Sundial.Progress
  alias Sundial.Tasks
  alias Sundial.Tasks.Task
  alias Phoenix.LiveView

  alias SundialWeb.SessionHandler
  alias Sundial.API.ClientAPI
  alias Sundial.API.TaskAPI

  def create(conn, %{"board_id" => board_id, "list_id" => list_id, "task" => task_params}) do
    access_token = SessionHandler.fetch_current_user_access_token(conn)
    client = ClientAPI.client(access_token)

    response = TaskAPI.create_task(client, %{"data" => task_params}, list_id, board_id)

    conn
      |> put_flash(:info, "task created successfully.")
      |> redirect(to: "/boards/" <> board_id)
  end
end
