defmodule SundialWeb.UserLive.Index do
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
  def handle_event("add-user", _params, socket) do
    {:reply, socket, push_redirect(socket, to: "/users/new")}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

   # TODO: Move to backend
  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Add a new user")
    |> assign(:status, Progress.list_status_options())
    |> assign(:serial_user, nil)
  end

   # TODO: Move to backend
  defp apply_action(socket, :edit, %{"id" => id, "return_to" => return_to}) do
    # user = Users.get_user!(id)
    user = UserAPI.get_user(%{id: id})
    user = for {key, val} <- user, into: %{}, do: {String.to_atom(key), val}

    socket
    |> assign(:page_title, "Edit User")
    |> assign(:status, Progress.list_status_options())
    |> assign(:user, user)
    |> assign(:serial_user, user)
    |> assign(:return_to, return_to)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:user, nil)
  end

  # TODO: Move to backend
  defp list_users(params) do
    # Users.list_users_by_position
    UserAPI.get_users(params)
  end

  # TODO: Move to backend
  defp list_users_by_default(params) do
    # Users.list_users
    UserAPI.get_users_default_sorting(params)
  end
end
