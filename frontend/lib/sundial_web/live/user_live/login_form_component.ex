defmodule SundialWeb.UserLive.LoginFormComponent do
  use SundialWeb, :live_component

  alias Sundial.API.UserAPI
  alias SundialWeb.SessionHandler

  @impl true
  def update(%{id: id} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end

  @impl true
  def handle_event("login", %{"user" => user_params}, socket) do
    {
      {:error, error},
      {:success_info, success_info},
      {:data, data}
    } = UserAPI.create_session(user_params)

    if success_info do
      socket = socket
      |> assign(:error, error)
      |> put_flash(:info, success_info)
      |> assign(:current_user, data)
      |> push_redirect(to: "/set_session")

      {:noreply,
      socket}
    else
      {:noreply,
      socket
        |> assign(:error, error)
        |> assign(:current_user, nil)}
    end
  end

  defp save_user(socket, :new, user_params) do
    {:noreply,
         socket
         |> put_flash(:info, "Account created successfully. You may now login.")
         |> push_redirect(to: "/signup")}
  end
end
