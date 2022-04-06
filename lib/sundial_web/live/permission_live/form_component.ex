defmodule SundialWeb.PermissionLive.FormComponent do
  use SundialWeb, :live_component

  alias Sundial.Boards

  @impl true
  def update(%{permission: permission} = assigns, socket) do
    changeset = Boards.change_permission(permission)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"permission" => permission_params}, socket) do
    changeset =
      socket.assigns.permission
      |> Boards.change_permission(permission_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"permission" => permission_params}, socket) do
    save_permission(socket, socket.assigns.action, permission_params)
  end

  defp save_permission(socket, :edit, permission_params) do
    case Boards.update_permission(socket.assigns.permission, permission_params) do
      {:ok, _permission} ->
        {:noreply,
         socket
         |> put_flash(:info, "Permission updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_permission(socket, :new, permission_params) do
    case Boards.create_permission(permission_params) do
      {:ok, _permission} ->
        {:noreply,
         socket
         |> put_flash(:info, "Permission created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
