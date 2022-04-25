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

  # @impl true
  # def handle_event("validate", %{"user" => user_params}, socket) do
  #   changeset =
  #     socket.assigns.user
  #     |> Users.change_user(user_params)
  #     |> Map.put(:action, :validate)

  #   {:noreply, assign(socket, :changeset, changeset)}
  # end

  @impl true
  def handle_event("login", %{"user" => user_params}, socket) do
    # {:noreply,
      # socket |> push_redirect(to: "/set_session")}

      #IO.inspect "loginhandleevent"

    {
      {:error, error},
      {:success_info, success_info},
      {:data, data}
    } = UserAPI.create_session(user_params)

    if success_info do
      # SessionHandler.set_current_user(socket, data)
      #IO.inspect "currentusersavedinsocket"

      socket = socket
      |> assign(:error, error)
      |> put_flash(:info, success_info)
      |> assign(:current_user, data)
      |> push_redirect(to: "/set_session")
      # |> push_redirect(to: "/boards")

      #IO.inspect socket, label: "socketinloginformcomp3"
      {:noreply,
      socket}
    else
      {:noreply,
      socket
        |> assign(:error, error)
        |> assign(:current_user, nil)}
    end
  end

  # defp save_user(socket, :edit, user_params) do

  #   UserAPI.update_user(socket.assigns.user.id, user_params)
  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "User updated successfully")
  #        |> push_redirect(to: "/users")}

    # case Users.update_user(socket.assigns.user, user_params) do
    #   {:ok, _user} ->
    #     {:noreply,
    #      socket
    #      |> put_flash(:info, "User updated successfully")
    #      |> push_redirect(to: socket.assigns.return_to)}

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     {:noreply, assign(socket, :changeset, changeset)}
    # end
  # end

  defp save_user(socket, :new, user_params) do
    # UserAPI.create_user(%{"data" => user_params})

    {:noreply,
         socket
         |> put_flash(:info, "Account created successfully. You may now login.")
         |> push_redirect(to: "/signup")}
    # case Users.create_user(user_params) do
    #   {:ok, _user} ->
    #     {:noreply,
    #      socket
    #      |> put_flash(:info, "User created successfully")
    #      |> push_redirect(to: socket.assigns.return_to)}

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     {:noreply, assign(socket, changeset: changeset)}
    # end
  end
end
