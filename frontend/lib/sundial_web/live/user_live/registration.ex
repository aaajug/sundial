defmodule SundialWeb.UserLive.Registration do
  use SundialWeb, :live_view

  alias Sundial.API.UserAPI

  @impl true
  def mount(params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("toggle-sorting", %{"sort_target" => sort_target}, socket) do
    {:reply, socket, push_redirect(socket, to: sort_target)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
  end

  defp apply_action(socket, :edit, %{"id" => id, "return_to" => return_to}) do
    socket
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:task, nil)
  end
end
