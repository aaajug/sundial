defmodule SundialWeb.BoardLive.FormComponent do
  use SundialWeb, :live_component

  alias Sundial.Boards
  alias Sundial.API.BoardAPI
  alias Sundial.API.ClientAPI

  @impl true
  def update(%{board: board} = assigns, socket) do
    # changeset = Boards.change_board(board)

    {:ok,
     socket
     |> assign(assigns)
    #  |> assign(:changeset, changeset)}
    }
  end

  # @impl true
  # def handle_event("validate", %{"board" => board_params}, socket) do
  #   changeset =
  #     socket.assigns.board
  #     |> Boards.change_board(board_params)
  #     |> Map.put(:action, :validate)

  #   {:noreply, assign(socket, :changeset, changeset)}
  # end

  # @impl true
  # def handle_event("")

  @impl true
  def handle_event("save", %{"board" => board_params}, socket) do
    save_board(socket, socket.assigns.action, board_params)
  end

  defp save_board(socket, :edit, board_params) do
    IO.inspect socket, label: "socketinboardformde2"
    IO.inspect board_params, label: "boardparamssubmit2"

    client = ClientAPI.client(socket.assigns.current_user_access_token)
    client |>
      BoardAPI.update_board(socket.assigns.board.id, board_params)

        {:noreply,
         socket
         |> put_flash(:info, "Board updated successfully")
         |> push_redirect(to: "/boards")}


    # case Boards.update_board(socket.assigns.board, board_params) do
    #   {:ok, _board} ->
    #     {:noreply,
    #      socket
    #      |> put_flash(:info, "Board updated successfully")
    #      |> push_redirect(to: socket.assigns.return_to)}

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     {:noreply, assign(socket, :changeset, changeset)}
    # end
  end

  defp save_board(socket, :new, board_params) do
    # IO.inspect socket, label: "socketinboardformde"
    # IO.inspect board_params, label: "boardparamssubmit"
    client = ClientAPI.client(socket.assigns.current_user_access_token)
    BoardAPI.create_board(client, %{"data" => board_params})


    {:noreply,
         socket
         |> put_flash(:info, "Board created successfully")
         |> push_redirect(to: "/boards")}
    # case Boards.create_board(board_params) do
    #   {:ok, _board} ->
    #     {:noreply,
    #      socket
    #      |> put_flash(:info, "Board created successfully")
    #      |> push_redirect(to: socket.assigns.return_to)}

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     {:noreply, assign(socket, changeset: changeset)}
    # end
  end
end
