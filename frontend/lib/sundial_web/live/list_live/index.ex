defmodule SundialWeb.ListLive.Index do
  use SundialWeb, :live_view

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

    {:ok, socket
    |> assign(:current_user_access_token, session["current_user_access_token"])
    |> assign(:lists, list_lists(session, board_id))
    |> assign(:drag_hook, "Drag")
    |> assign(:board_id, board_id)
    |> assign(:return_target, base_path)
    |> assign(:show_manage_header, true)}
  end

  @impl true
  def handle_event("refresh", %{"return_to" => return_to}, socket) do
    # IO.inspect params, label: "refreeshtasksa"
    {:noreply, push_redirect(socket, to: return_to)}
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

  defp apply_action(socket, :new_task, %{"board_id" => board_id, "list_id" => list_id}) do
    IO.inspect "new task in live"

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

    IO.inspect task, label: "taskobjectprint2"
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

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Lists")
    |> assign(:list, nil)
  end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #   list = Lists.get_list!(id)
  #   {:ok, _} = Lists.delete_list(list)

  #   {:noreply, assign(socket, :lists, list_lists())}
  # end

  defp list_lists(session, board_id) do
    client = ClientAPI.client(session["current_user_access_token"])

    client |>
      ListAPI.get_lists(board_id)
  end
end
