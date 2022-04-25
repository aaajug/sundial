defmodule SundialWeb.Live.Board.BoardComponent do
  use Phoenix.LiveComponent

  import SundialWeb.BoardLive.Sections

  alias Sundial.Boards
  alias Sundial.API.BoardAPI
  alias Sundial.API.ClientAPI
  alias SundialWeb.EnsureAuthenticated

  def mount(socket) do
    {:ok, socket}
  end

  def update(assigns, socket) do
    {:ok,
      socket
      |> assign(assigns)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    client = ClientAPI.client(socket.assigns.current_user_access_token)
    BoardAPI.delete_board(client, %{id: id})

    {:noreply,
     socket
       |> put_flash(:info, "Board successfully deleted.")
       |> push_redirect(to: "/boards")}
  end
end
