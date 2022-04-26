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
    current_user = Pow.Plug.current_user(conn)
    resource = Keyword.get(opts, :resource)
    action = action_name(conn)

    IO.inspect {resource, action}, label: "maybecontinuefunc7"

    # bypass
    cond do
      resource in [Board, Backend.Boards.Board] && action in @bypass_board_actions ->
        conn

      resource in [Task, Backend.Tasks.Task] && action in @bypass_task_actions ->
        conn

      true ->
        path_info = conn.path_info
        role = get_board_role(current_user, path_info)

        check(action, role, resource)
        |> maybe_continue(conn)
    end
  end

  defp maybe_continue(true, conn), do: conn

  defp maybe_continue(false, conn) do
    IO.inspect "You are not authorized for this action.", label: "maybecontinuefunc7"
    conn
      |> halt
      |> text(%{unauthorized: "You are not authorized for this action."})
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

  defp check(_action, _role, _resource), do: false

  defp get_role(user, board_id) do
    user_id = user.id

    # user
    # |> Repo.preload([permissions: from(permission in Permission, where: permission.user_id == ^user_id)])
    # |> Map.fetch!(:permissions)
    # user
    # |> Repo.preload([shared_boards: from(board in Board, where: board.id == ^board_id)])
    # |> Map.fetch!(:boards)
    # |> Enum.at(0)
  end

  defp get_board_role(user, path_info) do
    last_index = Enum.count(path_info) - 1

    board =
      cond do
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
        user_board_role =
          Boards.permission(user.id, board.id)
          |> Map.fetch!(:role)
    end
  end
end
