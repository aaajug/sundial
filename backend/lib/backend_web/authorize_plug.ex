defmodule BackendWeb.Authorize do
  import Plug.Conn
  import Phoenix.Controller
  import Backend.Authorization

  alias Backend.Router.Helpers, as: Routes
  alias Backend.Boards.Permission
  alias Backend.Repo
  alias Backend.Boards
  alias Backend.Lists
  alias Backend.Tasks
  alias Backend.Permissions.Permission

  @bypass_board_actions [:index, :shared_boards, :new, :create, :get_roles]
  @bypass_task_actions [:list_status_options]

  def init(opts), do: opts

  def call(conn, opts) do
    IO.inspect conn, label: "connprint2"

    current_user = Pow.Plug.current_user(conn)
    resource = Keyword.get(opts, :resource)
    action = action_name(conn)

    # bypass
    cond do
      resource in [Board, Backend.Boards.Board] && action in @bypass_board_actions ->
        conn

      resource in [Task, Backend.Tasks.Task] && action in @bypass_task_actions ->
        conn

      true ->
        role = get_board_role(current_user, conn.path_info, action, conn)

        IO.inspect {action, role, resource, check(action, role, resource)}, label: "authorizedebug3"

        check(action, role, resource)
        |> maybe_continue(conn)
    end
  end

  defp maybe_continue(true, conn), do: conn

  defp maybe_continue(false, conn) do
    response = %{error:
      %{
        "errors" => %{"unnauthorized access." => ["you are not authorized for this action"]},
        "message" => "Unauthorized access.",
        "status" => 500
      }
    }

    conn
      |> halt
      |> json(response)
  end

  defp check(:index, role, resource) do
    can(role) |> read?(resource)
  end

  defp check(action, role, resource) when action in [:new, :create] do
    can(role) |> create?(resource)
  end

  defp check(action, role, resource) when action in [:edit, :update] do
    can(role) |> update?(resource)
  end

  defp check(:delete, role, resource) do
    can(role) |> delete?(resource)
  end

  defp check(:list_tasks, role, resource) do
    can(role) |> read?(resource)
  end

  defp check(:update_positions, role, resource) do
    can(role) |> update?(resource)
  end

  defp check(:update_status, role, resource) do
    can(role) |> update?(resource)
  end

  defp check(:show, role, resource) do
    can(role) |> read?(resource)
  end

  defp ccheck(_action, nil, _resource), do: false
  defp check(_action, _role, _resource), do: false

  defp get_board_role(user, path_info, action, conn) do
    last_index = Enum.count(path_info) - 1

    IO.inspect {action, conn.body_params}, label: "authorizedebug5:bodyparams"

    board =
      cond do
        action == :update_positions ->
          IO.inspect "authorizedebug5:resourceupdate"
          list_id = conn.body_params["list_id"]
            |> Lists.get_list!
            |> Repo.preload(:board)
            |> Map.fetch!(:board)

        (boards_index = Enum.find_index(path_info, fn param -> param == "boards" end)) && last_index != boards_index ->
          path_info
            |> Enum.at(boards_index + 1)
            |> Boards.get_board!

        (lists_index = Enum.find_index(path_info, fn param -> param == "lists" end)) && last_index != lists_index ->
          path_info
            |> Enum.at(lists_index + 1)
            |> Lists.get_list!
            |> Repo.preload(:board)
            |> Map.fetch!(:board)

        (tasks_index = Enum.find_index(path_info, fn param -> param == "tasks" end)) && last_index != tasks_index->
          IO.inspect "intaskscheck"
          path_info
            |> Enum.at(tasks_index + 1)
            |> Tasks.get_task!
            |> Repo.preload(:list)
            |> Map.fetch!(:list)
            |> Repo.preload(:board)
            |> Map.fetch!(:board)

        true -> nil
      end

    case board do
      nil -> ""
      _ ->
        user_board_permission =
          Boards.permission(user.id, board.id)

          case user_board_permission do
            nil -> nil
            _ -> user_board_permission.role
          end
    end
  end
end
