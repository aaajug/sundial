defmodule SundialWeb.ListLive.Index do
  use SundialWeb, :live_view

  import SundialWeb.Live.Task.TaskModalComponent

  alias Sundial.Lists
  alias Sundial.Progress
  alias Sundial.Tasks.Task
  alias Sundial.API.ListAPI
  alias Sundial.API.TaskAPI
  alias Sundial.API.ClientAPI

  @impl true
  def mount(params, session, socket) do
    IO.inspect socket.assigns, label: "debuglistliveindexinmount"

    board_id = params["id"] || params["board_id"]
    base_path = "/boards/" <> board_id

    task = if params["task_id"] do
              client = ClientAPI.client(session["current_user_access_token"])
              TaskAPI.get_task(client, %{id: params["task_id"]})
          else
            nil
          end

    {:ok, socket
    |> assign(:current_user_access_token, session["current_user_access_token"])
    |> assign(:lists, list_lists(session["current_user_access_token"], board_id))
    |> assign(:drag_hook, "Drag")
    |> assign(:board_id, board_id)
    |> assign(:return_target, base_path)
    |> assign(:task, task)
    |> assign(:show_manage_header, true)}
  end

  @impl true
  def handle_event("refresh", %{"return_to" => return_to}, socket) do
    # #IO.inspect params, label: "refreeshtasksa"
    {:noreply, push_redirect(socket, to: return_to)}
  end


  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit_list, %{"id" => id}) do
    client = ClientAPI.client(socket.assigns.current_user_access_token)
    list = ListAPI.get_list(client, id)
    list = for {key, val} <- list, into: %{}, do: {String.to_atom(key), val}

    socket
    |> assign(:page_title, "Edit List")
    |> assign(:list, list)
    |> assign(:return_target, "/boards/" <> Integer.to_string(list.board_id))
  end

  defp apply_action(socket, :new_list, %{"id" => id}) do
    # TODO: use dynamic return_to

    # TODO: add user id
    params = %{list: %{list_id: id}}

    client = ClientAPI.client(socket.assigns.current_user_access_token)
    ListAPI.create_list(client, socket.assigns.board_id, params)

    socket
      |> put_flash(:info, "List created successfully")
      |> push_redirect(to: socket.assigns.return_target)
  # }

    # socket
    # |> assign(:page_title, "New List")
    # |> assign(:list, %List{})
  end

  defp apply_action(socket, :new_task, %{"board_id" => board_id, "list_id" => list_id}) do
    #IO.inspect "new task in live"

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
    # task = Tasks.get_task!(id)
    client = ClientAPI.client(socket.assigns.current_user_access_token)
    task = TaskAPI.get_task(client, %{id: id})
    task = for {key, val} <- task, into: %{}, do: {String.to_atom(key), val}

    # #IO.inspect task, label: "taskobjectprint2"
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

  defp apply_action(socket, :show_task, %{"board_id" => board_id, "task_id" => id}) do
    IO.inspect "debuglistliveindex: in apply action of :show_task"
    client = ClientAPI.client(socket.assigns.current_user_access_token)
    task = TaskAPI.get_task(client, %{id: id})

    socket
    |> assign(:task, task)
    # |> assign(:return_to, "/boards/" <> socket.assigns.board_id)
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
    # list = Lists.get_list!(id)
    # {:ok, _} = Lists.delete_list(list)

    {:noreply,
      socket
      |> push_redirect(to: "/boards/" <> socket.assigns.board_id)}
    # {:noreply, assign(socket, :lists, list_lists(socket.assigns.current_user_access_token, socket.assigns.board_id))}
  end

  defp list_lists(current_user_access_token, board_id) do
    client = ClientAPI.client(current_user_access_token)

    client |>
      ListAPI.get_lists(board_id)
  end
end
