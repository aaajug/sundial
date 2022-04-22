defmodule SundialWeb.ListLive.Index do
  use SundialWeb, :live_view

  alias Sundial.Lists
  alias Sundial.API.ListAPI

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :lists, list_lists())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit List")
    |> assign(:list, Lists.get_list!(id))
  end

  defp apply_action(socket, :new, %{"id" => id}) do
    # TODO: use dynamic return_to
    return_to = "/boards/1"

    # TODO: add user id
    params = %{list: %{list_id: id, user_id: 1}}
    ListAPI.create_list(params)

    socket
      |> put_flash(:info, "List created successfully")
      |> push_redirect(to: return_to)
  # }

    # socket
    # |> assign(:page_title, "New List")
    # |> assign(:list, %List{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Lists")
    |> assign(:list, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    list = Lists.get_list!(id)
    {:ok, _} = Lists.delete_list(list)

    {:noreply, assign(socket, :lists, list_lists())}
  end

  defp list_lists do
    ListAPI.get_lists
  end
end
