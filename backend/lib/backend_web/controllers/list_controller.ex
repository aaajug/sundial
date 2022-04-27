defmodule BackendWeb.ListController do
  use BackendWeb, :controller

  alias Backend.Lists
  alias Backend.Boards
  alias Backend.Lists.List

  plug BackendWeb.Authorize, resource: List

  def index(conn, %{"id" => board_id}) do
    user = Pow.Plug.current_user(conn)
    board = Boards.get_board!(board_id)
    lists = Lists.list_lists(board, user)
    serialized_lists = Lists.serialize(user, lists)
    serialized_board = Boards.serialize(user, board)

    json conn, %{board: serialized_board, lists: serialized_lists}
  end

  def create(conn, %{"id" => board_id, "list" => list_params}) do
    list_params = if list_params == %{} do
      Map.put(list_params, :title, "Unnamed list")
    end

    user = Pow.Plug.current_user(conn)
    board = Boards.get_board!(board_id)

    case Lists.create_list(user, board_id, list_params) do
      {:ok, list} ->
        IO.inspect "List Created"
        json conn, Lists.serialize(user, list)

      {:error, %Ecto.Changeset{} = changeset} ->
        text conn, "Failed to create list"
    end
  end

  def show(conn, %{"id" => id}) do
    user = Pow.Plug.current_user(conn)
    list = Lists.get_list!(id)

    json conn, %{data: Lists.serialize(user, list)}
  end

  def update(conn, %{"id" => id, "list" => list_params}) do
    list = Lists.get_list!(id)
    user = Pow.Plug.current_user(conn)

    case Lists.update_list(list, list_params) do
      {:ok, list} ->
        json conn, Lists.serialize(user, list)

      {:error, %Ecto.Changeset{} = changeset} ->
        text conn, "Failed to update list."
    end
  end

  def update_positions(conn, %{"insert_index" => insert_index, "list_id" => list_id}) do
    user = Pow.Plug.current_user(conn)

    case Lists.update_positions(user, insert_index, list_id) do
      {:ok, response} ->
        json conn, response
      {:error, message} ->
        text(conn, %{error: message})
    end
  end

  def delete(conn, %{"id" => id}) do
    list = Lists.get_list!(id)
    user = Pow.Plug.current_user(conn)

    case Lists.delete_list(list) do
      {:ok, list} ->
        json conn, Lists.serialize(user, list)
      {:error, _} ->
        text conn, "Failed to delete list."
    end
  end
end
