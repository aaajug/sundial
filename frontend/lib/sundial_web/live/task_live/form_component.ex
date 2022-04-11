defmodule AliveWeb.TaskLive.FormComponent do
  use SundialWeb, :live_component

  alias Sundial.Tasks
  alias Sundial.API.TaskAPI

  # TODO: Move to backend
  @impl true
  def update(%{task: task} = assigns, socket) do
    # changeset = Tasks.change_task(task)
    changeset = %Ecto.Changeset{action: nil, changes: %{}, errors: [], data: %Sundial.Tasks.Task{}, valid?: true}

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
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

  # TODO: Move to backend
  defp save_task(socket, :edit, task_params) do
    case Tasks.update_task(socket.assigns.task, task_params) do
      {:ok, _task} ->
        {:noreply,
         socket
         |> put_flash(:info, "Task updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  # TODO: Move to backend
  defp save_task(socket, :new, task_params) do
    # text(socket, API.send(task_params))
    TaskAPI.create_task(%{"data" => task_params})
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