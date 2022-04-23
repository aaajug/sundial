defmodule SundialWeb.Live.Board.BoardComponent do
  use Phoenix.LiveComponent

  import SundialWeb.BoardLive.Sections

  alias Sundial.Boards
  alias Sundial.API.BoardAPI
  alias SundialWeb.EnsureAuthenticated

  def mount(socket) do
    {:ok, socket}
  end

  # def preload(list_of_assigns) do
  #   # IO.inspect list_of_assigns, label: "listofassigns"
  #   # need to get current_user_access_id

  #   board_ids = Enum.map(list_of_assigns, & &1.id)
  #   boards = BoardAPI.get_boards(board_ids)

  #   Enum.map(list_of_assigns, fn(assigns) ->
  #     board = Enum.find(boards, fn(board) -> assigns.id == board["id"] end)
  #     Map.merge(assigns, %{board: board})
  #    end)
  # end

  def update(assigns, socket) do
    {:ok,
      socket
      |> assign(assigns)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    BoardAPI.delete_board(%{id: id})

    {:noreply,
     socket
       |> put_flash(:info, "Board successfully deleted.")
       |> push_redirect(to: "/boards")}
  end
end
