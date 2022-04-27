defmodule SundialWeb.ListLive.FormComponent do
  use SundialWeb, :live_component

  alias Sundial.Lists
  alias Sundial.API.ClientAPI
  alias Sundial.API.ListAPI

  @impl true
  def update(%{list: list} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end

  @impl true
  def handle_event("validate", %{"list" => list_params}, socket) do
    changeset =
      socket.assigns.list
      |> Lists.change_list(list_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"list" => list_params}, socket) do
    save_list(socket, socket.assigns.action, list_params)
  end

  defp save_list(socket, :edit_list, list_params) do
    client = ClientAPI.client(socket.assigns.current_user_access_token)
    ListAPI.update_list(client, socket.assigns.list.id, %{list: list_params})

    {:noreply,
      socket
      |> put_flash(:info, "List updated successfully")
      |> push_redirect(to: socket.assigns.return_to)}
  end

  defp save_list(socket, :new, list_params) do
    case Lists.create_list(list_params) do
      {:ok, _list} ->
        {:noreply,
         socket
         |> put_flash(:info, "List created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
