defmodule SundialWeb.ListLive.Index do
  use SundialWeb, :live_view

  import SundialWeb.Live.Task.TaskModalComponent
  import SundialWeb.ListLive.ModalContents

  alias Sundial.Lists
  alias Sundial.Progress
  alias Sundial.Tasks.Task
  alias Sundial.API.ListAPI
  alias Sundial.API.TaskAPI
  alias Sundial.API.ClientAPI

  @impl true
  def mount(params, session, socket) do
    board_id = params["id"] || params["board_id"]
    base_path = "/boards/" <> board_id

    task = if params["task_id"] do
              client = ClientAPI.client(session["current_user_access_token"])
              {_, _, {:data, data}}
                = TaskAPI.get_task(client, %{id: params["task_id"]})

              data
          else
            nil
          end

    response = list_lists(session["current_user_access_token"], board_id)

    {:ok, socket
    |> assign(:header_title, response["board"]["title"])
    |> assign(:current_user_access_token, session["current_user_access_token"])
    |> assign(:lists, response["lists"])
    |> assign(:board_title, response["board"]["title"])
    |> assign(:board, response["board"])
    |> assign(:drag_hook, "Drag")
    |> assign(:board_id, board_id)
    |> assign(:return_target, base_path)
    |> assign(:task, task)
    |> assign(:show_manage_header, true)}
  end

  @impl true
  def handle_event("refresh", %{"return_to" => return_to}, socket) do
    {:noreply, push_redirect(socket, to: return_to)}
  end

  @impl true
  def handle_event("dropped", %{"insert_index" => insert_index, "list_id" => list_id, "task_id" => task_id}, socket) do
    client = ClientAPI.client(socket.assigns.current_user_access_token)
    {{:error, error}, _, {:data, data}}
      = TaskAPI.update_positions(client, list_id, task_id, insert_index)

    if error do
      {:noreply,
      handle_error(error, socket)}
    else
      tasks = Enum.map(data["lists"], fn list ->
        Enum.map(list["tasks"], fn task ->
          task["id"]
        end)
      end)

      {:noreply,
      socket
      |> assign(:lists, data["lists"])}
    end
  end

  @impl true
  def handle_event("move_list", %{"list_id" => list_id, "insert_index" => insert_index}, socket) do
    client = ClientAPI.client(socket.assigns.current_user_access_token)
    lists = ListAPI.reorder_lists(client, list_id, insert_index)

    {:noreply,
    socket
    |> assign(:lists, lists)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit_list, %{"id" => id}) do
    client = ClientAPI.client(socket.assigns.current_user_access_token)

    { {:error, error},
    {:success_info, success_info},
    {:data, data}
    } = ListAPI.get_list(client, id)

    if error do
      handle_error(error, socket)
      |> push_redirect(to: "/boards")
    else
      list = for {key, val} <- data, into: %{}, do: {String.to_atom(key), val}

      socket
      |> assign(:page_title, "Edit List")
      |> assign(:list, list)
      |> assign(:return_target, "/boards/" <> Integer.to_string(list.board_id))
    end
  end

  defp apply_action(socket, :new_list, %{"id" => id}) do
    params = %{list: %{list_id: id}}

    client = ClientAPI.client(socket.assigns.current_user_access_token)
    ListAPI.create_list(client, socket.assigns.board_id, params)

    socket
      |> put_flash(:info, "List created successfully")
      |> push_redirect(to: socket.assigns.return_target)
  end

  defp apply_action(socket, :new_task, %{"board_id" => board_id, "list_id" => list_id}) do
    socket
    |> assign(:page_title, "Add a new task")
    |> assign(:status, Progress.list_status_options())
    |> assign(:task, %Task{})
    |> assign(:serial_task, nil)
    |> assign(:list_id, list_id)
    |> assign(:board_id, board_id)
    |> assign(:form_target, "/boards/"<>board_id<>"/lists/"<>list_id<>"/tasks")
  end

  defp apply_action(socket, :edit_task, %{"id" => id, "return_to" => return_to}) do
    client = ClientAPI.client(socket.assigns.current_user_access_token)
    { {:error, error},
    {:success_info, success_info},
    {:data, data}
    } = TaskAPI.get_task(client, %{id: id})

    if error do
      handle_error(error, socket)
      |> push_redirect(to: "/boards")
    else
      task = for {key, val} <- data, into: %{}, do: {String.to_atom(key), val}

      socket
      |> assign(:page_title, "Edit Task")
      |> assign(:list_id, "")
      |> assign(:board_id, "")
      |> assign(:form_target, "/tasks/" <> Integer.to_string(task.id))
      |> assign(:status, Progress.list_status_options())
      |> assign(:task, task)
      |> assign(:serial_task, task)
      |> assign(:return_to, return_to)
    end
  end

  defp apply_action(socket, :show_task, %{"board_id" => board_id, "task_id" => id}) do
    client = ClientAPI.client(socket.assigns.current_user_access_token)
    { {:error, error},
    {:success_info, success_info},
    {:data, task}
    } = TaskAPI.get_task(client, %{id: id})

    if error do
      handle_error(error, socket)
      |> push_redirect(to: "/boards")
    else
      socket
      |> assign(:task, task)
    end
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Lists")
    |> assign(:list, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    client = ClientAPI.client(socket.assigns.current_user_access_token)
    ListAPI.delete_list(client, id)

    {:noreply,
      socket
      |> push_redirect(to: "/boards/" <> socket.assigns.board_id)}
  end

  defp list_lists(current_user_access_token, board_id) do
    client = ClientAPI.client(current_user_access_token)

    client |>
      ListAPI.get_lists(board_id)
  end

  defp handle_error(error, socket) do
    {_, message} = error |> Enum.at(0)

    socket
    |> put_flash(:error, message)
  end
end
