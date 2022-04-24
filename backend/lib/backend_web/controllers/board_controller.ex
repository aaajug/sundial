defmodule BackendWeb.BoardController do
  use BackendWeb, :controller

  alias Backend.Boards
  alias Backend.Boards.Board
  alias Backend.Boards.Role

  # plug BackendWeb.Authorize,resource: BackendWeb.Boards.Board, except: [:new, :index]

  def index(conn, _params) do
    user = Pow.Plug.current_user(conn)
    IO.inspect user.boards, label: "userownedboards3"

    user_boards = Enum.at(Boards.list_boards(user.id), 0)

    # IO.inspect user_boards, label: "userboards"
    boards = user_boards.boards
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
    # board_params = Map.put(board_params, "user_id", 1)

    board_params = for {key, val} <- board_params, into: %{}, do: {String.to_atom(key), val}

    # fetch current user
    # create board for user
    user = Pow.Plug.current_user(conn)
    # board_params = Map.put(board_params, :user, user)

    permissions =  if Map.has_key?(board_params, :permissions) do
      board_params.permissions
    else
      nil
    end
    re = Boards.create_board(user, board_params, permissions)

    IO.inspect re, label: "createboardresultins"

    case re do
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
    # render(conn, "show.html", board: board)
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
    IO.inspect ("inupdateofboardcontroller")
    id = String.to_integer(params["id"])
    board = Boards.get_board!(id)

    board_params = Map.delete(params, "id")

    permissions = params["permissions"]
    board_params = Map.delete(board_params, "permissions")

    case Boards.update_board(board, permissions, board_params) do
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
