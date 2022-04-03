defmodule SundialWeb.LabelLive.FormComponent do
  use SundialWeb, :live_component

  alias Sundial.Labels

  @impl true
  def update(%{label: label} = assigns, socket) do
    changeset = Labels.change_label(label)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"label" => label_params}, socket) do
    changeset =
      socket.assigns.label
      |> Labels.change_label(label_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"label" => label_params}, socket) do
    save_label(socket, socket.assigns.action, label_params)
  end

  defp save_label(socket, :edit, label_params) do
    case Labels.update_label(socket.assigns.label, label_params) do
      {:ok, _label} ->
        {:noreply,
         socket
         |> put_flash(:info, "Label updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_label(socket, :new, label_params) do
    case Labels.create_label(label_params) do
      {:ok, _label} ->
        {:noreply,
         socket
         |> put_flash(:info, "Label created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
