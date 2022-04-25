defmodule SundialWeb.Live.Task.TaskShowComponent do
  use Phoenix.LiveComponent

  import Phoenix.HTML
  import SundialWeb.TaskLive.Sections

  alias Sundial.Progress.States
  alias Sundial.API.TaskAPI
  alias Sundial.API.ClientAPI

  def mount(socket) do
    {:ok, socket
      |> assign(%{status: States.get()})}
  end

  def update(assigns, socket) do
    {:ok,
      socket
      |> assign(assigns)}
  end

  def handle_event("update_status", params, socket) do
    client = ClientAPI.client(socket.assigns.current_user_access_token)
    client
    |> TaskAPI.update_task_status(socket.assigns.task["id"], %{"status" =>  params["status"]})

    {:noreply,
         socket
         |> put_flash(:info, "Task updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}
  end

  def handle_event("delete", %{"id" => id, "return_to" => return_to}, socket) do
    TaskAPI.delete_task(%{id: id})

    {:noreply,
     socket
       |> put_flash(:info, "Task successfully deleted.")
       |> push_redirect(to: return_to)}
  end

  def handle_event("save", %{"comment" => comment_params}, socket) do
    task_id = socket.assigns.task["id"];
    board_id = socket.assigns.task["board_id"]

    client = ClientAPI.client(socket.assigns.current_user_access_token)
    response = TaskAPI.create_comment(client, board_id, task_id, comment_params)

    {:noreply,
      socket
        |> assign(:task, response)
      }
  end
end
