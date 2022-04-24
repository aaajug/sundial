defmodule SundialWeb.BoardLive.SharedUsersComponent do
  use SundialWeb, :live_component


  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
    }
  end

  def handle_event("AddSharedUserField", params, socket) do
    IO.inspect "inAddSharedUserFieldevent"
    {:noreply, socket
    |> assign(:no_of_fields, socket.assigns.no_of_fields + 1)}
  end
end
