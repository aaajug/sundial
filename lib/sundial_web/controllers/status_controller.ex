defmodule SundialWeb.StatusController do
  use SundialWeb, :controller

  alias Sundial.Progress
  alias Sundial.Progress.Status

  def index(conn, _params) do
    status = Progress.list_status()
    render(conn, "index.html", status: status)
  end

  def new(conn, _params) do
    changeset = Progress.change_status(%Status{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"status" => status_params}) do
    case Progress.create_status(status_params) do
      {:ok, status} ->
        conn
        |> put_flash(:info, "Status created successfully.")
        |> redirect(to: Routes.status_path(conn, :show, status))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    status = Progress.get_status!(id)
    render(conn, "show.html", status: status)
  end

  def edit(conn, %{"id" => id}) do
    status = Progress.get_status!(id)
    changeset = Progress.change_status(status)
    render(conn, "edit.html", status: status, changeset: changeset)
  end

  def update(conn, %{"id" => id, "status" => status_params}) do
    status = Progress.get_status!(id)

    case Progress.update_status(status, status_params) do
      {:ok, status} ->
        conn
        |> put_flash(:info, "Status updated successfully.")
        |> redirect(to: Routes.status_path(conn, :show, status))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", status: status, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    status = Progress.get_status!(id)
    {:ok, _status} = Progress.delete_status(status)

    conn
    |> put_flash(:info, "Status deleted successfully.")
    |> redirect(to: Routes.status_path(conn, :index))
  end
end
