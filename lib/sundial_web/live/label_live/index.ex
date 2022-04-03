defmodule SundialWeb.LabelLive.Index do
  use SundialWeb, :live_view

  alias Sundial.Labels
  alias Sundial.Labels.Label

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :labels, list_labels())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Label")
    |> assign(:label, Labels.get_label!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Label")
    |> assign(:label, %Label{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Labels")
    |> assign(:label, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    label = Labels.get_label!(id)
    {:ok, _} = Labels.delete_label(label)

    {:noreply, assign(socket, :labels, list_labels())}
  end

  defp list_labels do
    Labels.list_labels()
  end
end
