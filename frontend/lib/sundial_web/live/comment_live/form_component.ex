defmodule SundialWeb.CommentLive.FormComponent do
  use SundialWeb, :live_component

  alias Sundial.Tasks
  alias Sundial.API.ClientAPI
  alias Sundial.API.TaskAPI

  @impl true
  def update(assigns, socket) do
    # IO.inspect assigns, label: "assignscommentliveinde2"
    {:ok,
     socket
     |> assign(assigns)}
  end

  @impl true
  def handle_event("validate", %{"comment" => comment_params}, socket) do
    changeset =
      socket.assigns.comment
      |> Tasks.change_comment(comment_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"comment" => comment_params}, socket) do
    save_comment(socket, :new, comment_params)
  end

  defp save_comment(socket, :edit, comment_params) do
    case Tasks.update_comment(socket.assigns.comment, comment_params) do
      {:ok, _comment} ->
        {:noreply,
         socket
         |> put_flash(:info, "Comment updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_comment(socket, :new, comment_params) do
    IO.inspect "handle_event_in: forcomponent"
    # IO.inspect socket.assigns, label: "assignsinsavecomments"
    # IO.inspect Map.keys(socket.assigns.assigns), label: "assignsinsavecomment2-mapkeys"
    task_id = socket.assigns.assigns.task["id"];
    board_id = socket.assigns.assigns.task["board_id"]

    client = ClientAPI.client(socket.assigns.assigns.current_user_access_token)
    response = TaskAPI.create_comment(client, board_id, task_id, comment_params)

    IO.inspect response, label: "APIresponse"

    # on success: update socket assigns.
    {:noreply,
      socket
        |> assign(:task, response)
      }

    # case Tasks.create_comment(comment_params) do
    #   {:ok, _comment} ->
    #     {:noreply,
    #      socket
    #      |> put_flash(:info, "Comment created successfully")
    #      |> push_redirect(to: socket.assigns.return_to)}

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     {:noreply, assign(socket, changeset: changeset)}
    # end
  end
end
