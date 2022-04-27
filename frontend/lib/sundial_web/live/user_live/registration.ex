defmodule SundialWeb.UserLive.Registration do
  use SundialWeb, :live_view

  alias Sundial.API.UserAPI

  @impl true
  def mount(params, session, socket) do
    {:ok,
      socket
        |> assign(:header_title, "Sundial")
        |> assign(:error, session["error"])
    }
  end

  @impl true
  def handle_event("toggle-sorting", %{"sort_target" => sort_target}, socket) do
    {:reply, socket, push_redirect(socket, to: sort_target)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new_session, _params) do
    socket
      |> assign(:show_login, true)
  end

  defp apply_action(socket, :destroy_session, _params) do
    {
      {:error, error},
      {:success_info, success_info},
      {:data, data}
    } = UserAPI.destroy_session

    if success_info do
      socket
        |> assign(:error, nil)
        |> put_flash(:info, success_info)
        |> assign(:data, nil)
        |> push_redirect(to: "/")
    else
      socket
        |> assign(:error, error)
        |> assign(:data, data)
    end
  end

  defp apply_action(socket, :new, _params) do
    {:noreply, socket}
  end

  defp apply_action(socket, :edit, %{"id" => id, "return_to" => return_to}) do
    socket
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:task, nil)
  end
end
