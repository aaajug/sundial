defmodule SundialWeb.FormViewLive do
  use Phoenix.LiveView, layout: {SundialWeb.LayoutView, "live.html"}

  alias SundialWeb.TaskView
  alias Sundial.Tasks

  def render(assigns) do
    # status = Progress.list_status_options()
    # changeset = Tasks.change_task(%Task{})
    # render(conn, "new.html", status: status, changeset: changeset)

    TaskView.render("new.html", assigns)
  end

  def mount(_params, session, socket) do
    {:ok, assign(socket, %{changeset: session["changeset"], status: session["status"]})}
  end
end
