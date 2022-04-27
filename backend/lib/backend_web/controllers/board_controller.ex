defmodule BackendWeb.BoardController do
  use BackendWeb, :controller

  alias Backend.Boards
  alias Backend.Boards.Board
  alias Backend.Boards.Role

  plug BackendWeb.Authorize, resource: Board, except: [:index, :shared_boards, :new, :create, :get_roles]

  def index(conn, _params) do
    user = Pow.Plug.current_user(conn)
    user_boards = Enum.at(Boards.list_boards(user.id), 0)

    serialized_boards =
      if user_boards do
        boards = user_boards.boards
        Boards.serialize(user, boards)
      else
        []
      end

    json conn, %{data: serialized_boards}
  end

  def shared_boards(conn, _params) do
    user = Pow.Plug.current_user(conn)
    boards = Boards.list_shared_boards(user)
    serialized_boards = Boards.serialize(user, boards)

    json conn, %{data: serialized_boards}
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
        json conn, %{data: Boards.serialize(user, board)}

      {:error, %Ecto.Changeset{} = changeset} ->
        text conn, "Error creating board"
    end
  end

  def show(conn, %{"id" => id}) do
    user = Pow.Plug.current_user(conn)

    board = Boards.get_board(user, id)

    json conn, %{data: Boards.serialize(user, board)}
  end

  def get_roles(conn, _params) do
    json conn, %{data: Role.get_names}
  end

  def update(conn, params) do
    user = Pow.Plug.current_user(conn)

    id = String.to_integer(params["id"])
    board = Boards.get_board!(id)

    board_params = Map.delete(params, "id")

    permissions = params["permissions"]
    board_params = Map.delete(board_params, "permissions")

    case Boards.update_board(board, permissions, board_params) do
      {:ok, board} ->
        json conn, %{data: Boards.serialize(user, board)}

      {:error, %Ecto.Changeset{} = changeset} ->
        text conn, "Failed to update board."
    end
  end

  def delete(conn, %{"id" => id}) do
    board = Boards.get_board!(id)
    {:ok, _board} = %{data: Boards.delete_board(board)}

    text conn, "Board deleted successfully."
  end
end
