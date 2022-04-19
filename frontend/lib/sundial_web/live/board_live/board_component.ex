defmodule SundialWeb.Live.Board.BoardComponent do
  use Phoenix.LiveComponent

  import SundialWeb.BoardLive.Sections

  # alias Sundial.Progress.States
  alias Sundial.Boards
  alias Sundial.API.BoardAPI

  def mount(socket) do
    {:ok, socket}
  end

  def preload(list_of_assigns) do
    board_ids = Enum.map(list_of_assigns, & &1.id)
    boards = BoardAPI.get_boards(board_ids)

    Enum.map(list_of_assigns, fn(assigns) ->
      board = Enum.find(boards, fn(board) -> assigns.id == board["id"] end)
      Map.merge(assigns, %{board: board})
     end)
  end

  def update(assigns, socket) do
    {:ok,
      socket
      |> assign(assigns)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    IO.inspect(id, label: "inboard delete event")

    BoardAPI.delete_board(%{id: id})

    {:noreply,
     socket
       |> put_flash(:info, "Board successfully deleted.")
       |> push_redirect(to: "/boards")}
  end
end
