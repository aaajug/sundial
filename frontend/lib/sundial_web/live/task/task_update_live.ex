defmodule SundialWeb.Live.TaskUpdateLive do
  use Phoenix.LiveView
  # alias SundialWeb.TaskView

  def render(assigns) do
    # IO.inspect @socket
    ~H"""
      update task
    """
    # TaskView.render("index.html", assigns)
  end

  def mount(_params, _session, socket) do
    # TODO: Refactor assignment, use pipe operator; only pass integers/struct
    # {:ok, assign(socket, %{conn: session["conn"], tasks: session["tasks"], status: session["status"]})}
    # TODO: Remove status from here, and also from the controller. Will be handled by TaskComponent instead.
    {:ok, assign(socket, %{})}
    # IO.inspect "debug in: mount"
    # {:ok, socket}
  end

  # def mount(_params, session, socket) do
  #   # TODO: Refactor assignment, use pipe operator; only pass integers/struct
  #   {:ok, assign(socket, %{tasks: session["tasks"], status: session["status"]})}
  # end

end
