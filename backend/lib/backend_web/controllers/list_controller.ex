defmodule BackendWeb.ListController do
  use BackendWeb, :controller

  alias Backend.Lists
  alias Backend.Lists.List

  def index(conn, _params) do
    lists = Lists.list_lists()
    serialized_lists = Lists.serialize(lists)

    json conn, serialized_lists
    # render(conn, "index.html", lists: lists)
  end

  def new(conn, _params) do
    changeset = Lists.change_list(%List{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"list" => list_params}) do
    IO.inspect list_params, label: "listcreateparams"
    case Lists.create_list(list_params) do
      {:ok, list} ->
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
