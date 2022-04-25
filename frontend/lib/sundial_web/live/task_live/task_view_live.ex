defmodule SundialWeb.TaskViewLive do
  use Phoenix.LiveView, layout: {SundialWeb.LayoutView, "live.html"}

  alias SundialWeb.TaskView
  alias Sundial.Tasks

  def render(assigns) do
    TaskView.render("index.html", assigns)
  end

  def mount(params, _session, socket) do
    sort_by = params["sort_by"]
    # TODO: Refactor assignment, use pipe operator; only pass integers/struct
    # {:ok, assign(socket, %{conn: session["conn"], tasks: session["tasks"], status: session["status"]})}
    # TODO: Remove status from here, and also from the controller. Will be handled by TaskComponent instead.
    # put_flash(socket, :info, "It worked!")
    # #IO.inspect socket
    if Tasks.is_all_position_nil?(), do: Tasks.initialize_positions
    tasks = if sort_by == "default" do
              Tasks.list_tasks()
            else
              Tasks.list_tasks_by_position()
            end

    {:ok, assign(socket, %{tasks: tasks})}
    # {:ok, assign(socket, %{tasks: session["tasks"], status: session["status"]})}
    # #IO.inspect "debug in: mount"
    # {:ok, socket}
  end

  # def handle_info({Tasks, _, socket) do
  #   {:stop,
  #    socket
  #    # |> put_flash(:error, "This user has been deleted.")
  #    |> redirect(to: Routes.live_path(socket, UserLive.Index))}
  # end

  # def handle_params(
  #      %{"page" => page_num, "search" => %{"query" => query, "value" => value}},
  #      _uri,
  #      %{assigns: %{search: search}} = socket
  #    ) do
  #  socket =
  #    socket
  #    |> assign(:page, page_num)
  #    |> assign(:search, Search.update(query, value))
  #    |> assign(:messages, messages_search(query, value, page_num))

  #  {:noreply, socket}
  # end

  # def preload(_assigns) do
  #   #IO.inspect "in taskviewlive preload"

  #   # Tasks.is_all_position_nil?(), do: Tasks.initialize_positions
  #   # tasks = Tasks.list_tasks()
  #   # tasks = Tasks.serialize(tasks)
  #   # status = Progress.list_status()
  # end

  def handle_info(msg, socket) do
    #IO.inspect "Task view handle info"
    #IO.inspect msg

    {:noreply, socket}
  end
end
