defmodule SundialWeb.BoardLive.Index do
  use SundialWeb, :live_view

  alias Sundial.Boards
  alias Sundial.Boards.Board
  alias Sundial.API.BoardAPI
  alias Sundial.API.ListAPI
  alias Sundial.API.ClientAPI
  alias SundialWeb.EnsureAuthenticated

  # plug SundialWeb.EnsureAuthenticated

  @impl true
  def mount(_params, session, socket) do
    boards = list_boards(session)

    {:ok, socket
      |> assign(:current_user_access_token, session["current_user_access_token"])
      |> assign(:boards, boards)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  # defp apply_action(socket, :edit_list, %{"id" => id}) do
  #   client = ClientAPI.client(socket.assigns.current_user_access_token)
  #   list = ListAPI.get_list(client, id)

  #   socket
  #   |> assign(:page_title, "Edit List")
  #   |> assign(:list, list)
  # end

  defp apply_action(socket, :edit, %{"id" => id}) do
    client = ClientAPI.client(socket.assigns.current_user_access_token)
    board = client
     |>  BoardAPI.get_board(%{id: id})

    board = for {key, val} <- board, into: %{}, do: {String.to_atom(key), val}

    socket
    |> assign(:page_title, "Edit Board")
    |> assign(:roles, BoardAPI.get_roles)
    |> assign(:board, board)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Board")
    |> assign(:roles, BoardAPI.get_roles)
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
    client = ClientAPI.client(socket.assigns.current_user_access_token)
    BoardAPI.delete(client, %{id: id})

    {:noreply, assign(socket, :boards, list_boards(""))}
  end

  @impl true
  def handle_event("add_shared_user_field", %{"return_to" => return_to}, socket) do
    # save current form
    # update no. of fields
    # push redirect to return_to
    {:noreply, socket
    |> push_redirect(to: return_to)}
  end

  defp list_boards(session) do
    client = ClientAPI.client(session["current_user_access_token"])
    client
      |> BoardAPI.get_boards
  end

  # defp ensure_authenticated(access_token, socket) do
  #   #IO.inspect !EnsureAuthenticated.is_authenticated?(access_token), label: "ensureauthdbclient"
  #   if !EnsureAuthenticated.is_authenticated?(access_token) do
  #     socket
  #       |> push_redirect(to: "/login")
  #   else
  #     socket
  #   end
  # end
end
