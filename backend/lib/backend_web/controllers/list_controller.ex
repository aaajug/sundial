defmodule BackendWeb.ListController do
  use BackendWeb, :controller

  alias Backend.Lists
  alias Backend.Boards
  alias Backend.Lists.List

  def index(conn, %{"id" => board_id}) do
    user = Pow.Plug.current_user(conn)
    lists = Lists.list_lists(user, board_id)
    serialized_lists = Lists.serialize(lists)

    json conn, serialized_lists
    # render(conn, "index.html", lists: lists)
  end

  def new(conn, _params) do
    changeset = Lists.change_list(%List{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"id" => board_id, "list" => list_params}) do
    # list_params = for {key, val} <- list_params, into: %{}, do: {String.to_atom(key), val}
    list_params = if list_params == %{} do
      Map.put(list_params, :title, "Unnamed list")
    end

    user = Pow.Plug.current_user(conn)
    board = Boards.get_board!(board_id)

    case Lists.create_list(user, board_id, list_params) do
      {:ok, list} ->
        IO.inspect "List Created"
        json conn, Lists.serialize(list)
        # conn
        # |> put_flash(:info, "List created successfully.")
        # |> redirect(to: Routes.list_path(conn, :show, list))

      {:error, %Ecto.Changeset{} = changeset} ->
        text conn, "Failed to create list"
        # render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    list = Lists.get_list!(id)
    json conn, Lists.serialize(list)
    # render(conn, "show.html", list: list)
  end

  def edit(conn, %{"id" => id}) do
    list = Lists.get_list!(id)
    changeset = Lists.change_list(list)
    render(conn, "edit.html", list: list, changeset: changeset)
  end

  def update(conn, %{"id" => id, "list" => list_params}) do
    list = Lists.get_list!(id)

    case Lists.update_list(list, list_params) do
      {:ok, list} ->
        json conn, Lists.serialize(list)
        # conn
        # |> put_flash(:info, "List updated successfully.")
        # |> redirect(to: Routes.list_path(conn, :show, list))

      {:error, %Ecto.Changeset{} = changeset} ->
        text conn, "Failed to update list."
        # render(conn, "edit.html", list: list, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    list = Lists.get_list!(id)
    case Lists.delete_list(list) do
      {:ok, list} ->
        json conn, Lists.serialize(list)
      {:error, _} ->
        text conn, "Failed to delete list."
    end


    # conn
    # |> put_flash(:info, "List deleted successfully.")
    # |> redirect(to: Routes.list_path(conn, :index))
  end
end
