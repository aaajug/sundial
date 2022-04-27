defmodule SundialWeb.TaskLive.Index do
  use SundialWeb, :live_view

  alias Sundial.Tasks
  alias Sundial.Tasks.Task
  alias Sundial.Progress
  alias Sundial.API.TaskAPI
  alias Sundial.API.ClientAPI
  alias SundialWeb.SessionHandler

  @impl true
  def mount(params, session, socket) do
    base_path = "/boards/" <> (params["id"] || "")

    sort = if Map.has_key?(params, "sort"), do: params["sort"], else: nil

    socket = socket
    |> assign(:current_user_access_token, session["current_user_access_token"])

    socket = case sort do
      "default" ->
        socket
          |> assign(:sort_class, "is-warning is-active is-focused")
          |> assign(:sort_target, base_path)
          |> assign(:return_target, base_path <> "/?sort=default")
          |> assign(:drag_hook, "None")
          |> assign(:sort_label, "Disable")
          |> assign(:tasks, list_tasks_by_default(session, %{board_id: params["id"]}))

      _ ->
        socket
          |> assign(:sort_class, "sort-custom-button")
          |> assign(:sort_target, base_path <> "/?sort=default")
          |> assign(:return_target, base_path)
          |> assign(:drag_hook, "Drag")
          |> assign(:sort_label, "Enable")
          |> assign(:tasks, list_tasks(session, %{board_id: params["id"]}))
    end

    {:ok, assign(socket, :show_manage_header, true)}
  end

  @impl true
  def handle_event("toggle-sorting", %{"sort_target" => sort_target}, socket) do
    {:reply, socket, push_redirect(socket, to: sort_target)}
  end

  @impl true
  def handle_event("add-task", _params, socket) do
    {:reply, socket, push_redirect(socket, to: "/tasks/new")}
  end

  @impl true
  def handle_event("dropped", %{"list" => list}, socket) do
    TaskAPI.update_positions(%{list: list})

    {:noreply,
    socket
    |> put_flash(:info, "Tasks reordered successfully")
    |> push_redirect(to: "/")}
  end

  @impl true
  def handle_event("move_column", _params, socket) do
    socket = put_flash(socket, :error, "Dropping to another column not allowed. Please use the status buttons on the left side of each task card.")
    {:reply, socket, push_redirect(socket, to: "/")}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Add a new task")
    |> assign(:status, Progress.list_status_options())
    |> assign(:task, %Task{})
    |> assign(:serial_task, nil)
  end

  defp apply_action(socket, :edit, %{"id" => id, "return_to" => return_to}) do
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

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:task, nil)
  end

  defp list_tasks(session, params) do
    client = ClientAPI.client(session["current_user_access_token"])

    client
      |> TaskAPI.get_tasks(params)
  end

  defp list_tasks_by_default(session, params) do
    client = ClientAPI.client(session["current_user_access_token"])

    client |>
      TaskAPI.get_tasks_default_sorting
  end

  defp handle_error(error, socket) do
    {_, message} = error |> Enum.at(0)

    socket
    |> put_flash(:error, message)
  end
end
