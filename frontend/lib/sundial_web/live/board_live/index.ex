defmodule SundialWeb.BoardLive.Index do
  use SundialWeb, :live_view

  alias Sundial.Boards
  alias Sundial.Boards.Board
  alias Sundial.API.BoardAPI
  alias Sundial.API.ClientAPI
  alias SundialWeb.EnsureAuthenticated

  # plug SundialWeb.EnsureAuthenticated

  @impl true
  def mount(_params, session, socket) do
    boards = list_boards(session)

    {:ok, assign(socket, :boards, boards)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    board = BoardAPI.get_board(%{id: id})
    board = for {key, val} <- board, into: %{}, do: {String.to_atom(key), val}

    socket
    |> assign(:page_title, "Edit Board")
    |> assign(:board, board)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Board")
    |> assign(:board, %Board{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Boards")
    |> assign(:board, nil)
  end

  @impl true
  def handle_event("refresh", _params, socket) do
    {:noreply, push_redirect(socket, to: "/boards")}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    # board = Boards.get_board!(id)
    # {:ok, _} = Boards.delete_board(board)
    BoardAPI.delete(%{id: id})

    {:noreply, assign(socket, :boards, list_boards(""))}
  end

  defp list_boards(session) do
    client = ClientAPI.client(session["current_user_access_token"])
    client
      |> BoardAPI.get_boards
  end

  # defp ensure_authenticated(access_token, socket) do
  #   IO.inspect !EnsureAuthenticated.is_authenticated?(access_token), label: "ensureauthdbclient"
  #   if !EnsureAuthenticated.is_authenticated?(access_token) do
  #     socket
  #       |> push_redirect(to: "/login")
  #   else
  #     socket
  #   end
  # end
end
