defmodule SundialWeb.BoardLive.Index do
  use SundialWeb, :live_view

  alias Sundial.Boards
  alias Sundial.Boards.Board
  alias Sundial.API.BoardAPI
  alias Sundial.API.ListAPI
  alias Sundial.API.ClientAPI
  alias SundialWeb.EnsureAuthenticated

  @impl true
  def mount(params, session, socket) do
    {boards, refresh_target, header_title} = if params["shared"]do
      {list_shared_boards(session["current_user_access_token"]),
      "/boards?shared=true",
      "Boards Shared with me"}
    else
      {list_boards(session["current_user_access_token"]),
      "/boards",
      "My Boards"}
    end

    {:ok, socket
      |> assign(:header_title, header_title)
      |> assign(:current_user_access_token, session["current_user_access_token"])
      |> assign(:boards, boards)
      |> assign(:refresh_target, refresh_target)
      |> assign(:show_manage_header, false)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    client = ClientAPI.client(socket.assigns.current_user_access_token)

    {{:error, error}, _, {:data, data}}
    = client |> BoardAPI.get_board(%{id: id})

    if error do
      handle_error(error, socket)
      |> push_redirect(to: "/boards")
    else
      board = for {key, val} <- data, into: %{}, do: {String.to_atom(key), val}
      {_, _, {:data, roles}} = BoardAPI.get_roles

      if board.actions_allowed do
        socket
        |> assign(:page_title, "Edit Board")
        |> assign(:roles, roles)
        |> assign(:board, board)
      else
        socket
        |> push_redirect(to: "/boards?shared=true")
      end
    end
  end

  defp apply_action(socket, :new, _params) do
    {_, _, {:data, roles}} = BoardAPI.get_roles

    socket
    |> assign(:page_title, "New Board")
    |> assign(:roles, roles)
    |> assign(:board, %Board{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Boards")
    |> assign(:board, nil)
  end

  @impl true
  def handle_event("refresh", _params, socket) do
    {:noreply, push_redirect(socket, to: socket.assigns.refresh_target)}
  end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #   client = ClientAPI.client(socket.assigns.current_user_access_token)
  #   BoardAPI.delete(client, %{id: id})

  #   {:noreply, assign(socket, :boards, list_boards(""))}
  # end

  @impl true
  def handle_event("add_shared_user_field", %{"return_to" => return_to}, socket) do
    # save current form
    # update no. of fields
    # push redirect to return_to
    {:noreply, socket
    |> push_redirect(to: return_to)}
  end

  defp list_boards(access_token) do
    client = ClientAPI.client(access_token)
    {_, _, {:data, data}} = client |> BoardAPI.get_boards

    data
  end

  defp list_shared_boards(access_token) do
    client = ClientAPI.client(access_token)
    {_, _, {:data, data}} = client |> BoardAPI.get_shared_boards

    data
  end

  defp handle_error(error, socket) do
    {_, message} = error |> Enum.at(0)

    socket
    |> put_flash(:error, message)
  end
end
