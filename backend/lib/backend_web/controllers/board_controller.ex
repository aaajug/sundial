defmodule BackendWeb.BoardController do
  use BackendWeb, :controller

  alias Backend.Boards
  alias Backend.Boards.Board

  def index(conn, _params) do
    boards = Boards.list_boards()
    serialized_boards = Boards.serialize(boards)

    json conn, serialized_boards
  end

  # def get_task(conn, %{"id" => id}) do
  #   tasks =
  # end

  def new(conn, _params) do
    changeset = Boards.change_board(%Board{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"data" => board_params}) do
    board_params = Map.put(board_params, "user_id", 1)

    case Boards.create_board(board_params) do
      {:ok, board} ->
        json conn, Boards.serialize(board)

      {:error, %Ecto.Changeset{} = changeset} ->
        text conn, "Error creating board"
    end
  end

  def show(conn, %{"id" => id}) do
    board = Boards.get_board!(id)

    json conn, Boards.serialize(board)
    # render(conn, "show.html", board: board)
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

    case Boards.update_board(board, board_params) do
      {:ok, board} ->
        json conn, Boards.serialize(board)
        # conn
        # |> put_flash(:info, "Board updated successfully.")
        # |> redirect(to: Routes.board_path(conn, :show, board))

      {:error, %Ecto.Changeset{} = changeset} ->
        text conn, "Failed to update board."
    end
  end

  def delete(conn, %{"id" => id}) do
    board = Boards.get_board!(id)
    {:ok, _board} = Boards.delete_board(board)

    text conn, "Board deleted successfully."
    # conn
    # |> put_flash(:info, "Board deleted successfully.")
    # |> redirect(to: Routes.board_path(conn, :index))
  end
end
