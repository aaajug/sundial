defmodule SundialWeb.BoardLive.Show do
  use SundialWeb, :live_view

  alias Sundial.Boards
  alias Sundial.API.BoardAPI

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    board = BoardAPI.get_board(%{id: id})

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:board, board)}
  end

  defp page_title(:show), do: "Show Board"
  defp page_title(:edit), do: "Edit Board"
end
