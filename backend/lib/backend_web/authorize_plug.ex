defmodule BackendWeb.Authorize do
  import Plug.Conn
  import Phoenix.Controller
  import Backend.Authorization

  alias Backend.Router.Helpers, as: Routes
  alias Backend.Boards.Permission
  alias Backend.Repo

  def init(opts), do: opts

  def call(conn, opts) do
    # to get role:
    # get current user
    # get user role on specific board using permissions table

    current_user = Pow.Plug.current_user(conn)
    role = conn.assigns.current_user.role
    resource = Keyword.get(opts, :resource)
    action = action_name(conn)

    check(action, role, resource)
    |> maybe_continue(conn)
  end

  defp maybe_continue(true, conn), do: conn

  defp maybe_continue(false, conn) do
    conn
    |> put_flash(:error, "You're not authorized to do that!")
    |> redirect(to: Routes.page_path(conn, :index))
    |> halt()
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
end
