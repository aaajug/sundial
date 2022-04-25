defmodule SundialWeb.TaskLive.FormComponent do
  use SundialWeb, :live_component

  alias Sundial.Tasks
  alias Sundial.API.TaskAPI
  alias Sundial.API.ClientAPI

  # TODO: Move to backend
  @impl true
  def update(%{task: _task} = assigns, socket) do
    # changeset = Tasks.change_task(task)
    # changeset = %{action: nil, changes: %{}, errors: [], data: %Sundial.Tasks.Task{}, valid?: true}

    {:ok,
     socket
     |> assign(assigns)
    #  |> assign(:changeset, changeset)}
  }
  end

  @impl true
  def handle_event("validate", %{"task" => task_params}, socket) do
    changeset =
      socket.assigns.task
      |> Tasks.change_task(task_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"task" => task_params}, socket) do
    save_task(socket, socket.assigns.action, task_params)
  end

  # defp save_task(socket, :edit_task, task_params) do
  #   #IO.inspect "savetaskeditaskpasson"
  #   save_task(socket, :edit, task_params)
  # end
  # TODO: Move to backend
  defp save_task(socket, :edit_task, task_params) do
    # #IO.inspect "savetaskedit"
    # case TaskAPI.update_task(socket.assigns.task.id, task_params) do
      client = ClientAPI.client(socket.assigns.current_user_access_token)
      TaskAPI.update_task(client, socket.assigns.task.id, task_params)
      # {:ok, _task} ->
        {:noreply,
         socket
         |> put_flash(:info, "Task updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      # {:error, %Ecto.Changeset{} = changeset} ->
      #   {:noreply, assign(socket, :changeset, changeset)}
    # end
  end

  # TODO: Move to backend
  defp save_task(socket, :new_task, task_params) do
    # text(socket, API.send(task_params))
    #IO.inspect socket, label: "2socketnewtaskeventtaskform"
    client = ClientAPI.client(socket.assigns.current_user_access_token)
    #IO.inspect task_params, label: "task_paramsdebug"
    TaskAPI.create_task(client, %{"data" => task_params}, socket.assigns.list_id, socket.assigns.board_id)
    # case Tasks.create_task(task_params) do
    #   {:ok, _task} ->
        {:noreply,
         socket
         |> put_flash(:info, "Task created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     {:noreply, assign(socket, changeset: changeset)}
    # end
  end
end
