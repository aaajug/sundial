defmodule SundialWeb.PermissionLive.Show do
  use SundialWeb, :live_view

  alias Sundial.Boards

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:permission, Boards.get_permission!(id))}
  end

  defp page_title(:show), do: "Show Permission"
  defp page_title(:edit), do: "Edit Permission"
end
