defmodule SundialWeb.Live.TaskUpdateLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
      update task
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, %{})}
  end
end
