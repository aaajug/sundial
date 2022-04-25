
defmodule SundialWeb.Live.Task.CommentComponent do
  use Phoenix.LiveComponent

  import SundialWeb.TaskLive.Sections

  alias Sundial.Progress.States
  alias Sundial.Tasks
  alias Sundial.API.TaskAPI
  alias Sundial.API.ClientAPI

  def mount(socket) do
    {:ok, socket}
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
end
