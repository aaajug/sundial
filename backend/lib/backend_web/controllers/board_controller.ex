defmodule BackendWeb.BoardController do
  use BackendWeb, :controller

  alias Backend.Boards
  alias Backend.Boards.Board
  alias Backend.Boards.Role

  plug BackendWeb.Authorize, resource: Board, except: [:index, :shared_boards, :new, :create, :get_roles]

  def index(conn, _params) do
    user = Pow.Plug.current_user(conn)
    user_boards = Enum.at(Boards.list_boards(user.id), 0)

    boards = user_boards.boards
    serialized_boards = Boards.serialize(boards)

    json conn, serialized_boards
  end

  def shared_boards(conn, _params) do
    user = Pow.Plug.current_user(conn)
    boards = Boards.list_shared_boards(user)
    serialized_boards = Boards.serialize(boards)

    json conn, serialized_boards
  end

  def new(conn, _params) do
    changeset = Boards.change_board(%Board{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"data" => board_params}) do
    board_params = for {key, val} <- board_params, into: %{}, do: {String.to_atom(key), val}

    user = Pow.Plug.current_user(conn)

    permissions =
      if Map.has_key?(board_params, :permissions) do
        board_params.permissions
      else
        nil
      end

    case Boards.create_board(user, board_params, permissions) do
      {:ok, board} ->
        json conn, Boards.serialize(board)

      {:error, %Ecto.Changeset{} = changeset} ->
        text conn, "Error creating board"
    end
  end

  def show(conn, %{"id" => id}) do
    user = Pow.Plug.current_user(conn)

    board = Boards.get_board(user, id)

    json conn, Boards.serialize(board)
  end

  def get_roles(conn, _params) do
    json conn, Role.get_names
  end

  def edit(conn, %{"id" => id}) do
    board = Boards.get_board!(id)
    changeset = Boards.change_board(board)
    render(conn, "edit.html", board: board, changeset: changeset)
  end

  def update(conn, params) do
    id = String.to_integer(params["id"])
    board = Boards.get_board!(id)

    board_params = Map.delete(params, "id")

    permissions = params["permissions"]
    board_params = Map.delete(board_params, "permissions")

    case Boards.update_board(board, permissions, board_params) do
      {:ok, board} ->
        json conn, Boards.serialize(board)

      {:error, %Ecto.Changeset{} = changeset} ->
        text conn, "Failed to update board."
    end
  end

  def delete(conn, %{"id" => id}) do
    board = Boards.get_board!(id)
    {:ok, _board} = Boards.delete_board(board)

    text conn, "Board deleted successfully."
  end
end
