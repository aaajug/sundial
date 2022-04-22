defmodule SundialWeb.DestroySessionPlug do
  use SundialWeb, :controller
  import Plug.Conn, only: [halt: 1, delete_session: 2]

  alias Phoenix.Controller
  alias Plug.Conn
  alias Pow.Plug
  alias Sundial.API.ClientAPI
  alias Sundial.API.UserAPI

  def init(config), do: config

  def call(conn, _params) do
    conn
      |> delete_session("current_user_access_token")
      |> delete_session("current_user_email")
      |> delete_session("success_info")
      |> delete_session("error")
  end

  defp is_authenticated?(conn) do
    current_user_access_token = Conn.get_session(conn, :current_user_access_token)

    client = ClientAPI.client(current_user_access_token)
    # IO.inspect client, label: "client1"
    # IO.inspect current_user_access_token, label: "current_user_access_tokendb2"
    # IO.inspect client, label: "clientdb"
    # IO.inspect UserAPI.check_authentication(client), label: "label:checkauthtrues"

    UserAPI.check_authentication(client) == "true"
  end

  defp has_role?(nil, _roles), do: false
  defp has_role?(user, roles) when is_list(roles), do: Enum.any?(roles, &has_role?(user, &1))
  defp has_role?(user, role) when is_atom(role), do: has_role?(user, Atom.to_string(role))
  defp has_role?(%{role: role}, role), do: true
  defp has_role?(_user, _role), do: false

  defp maybe_halt(true, conn), do: conn
  defp maybe_halt(_any, conn) do
    conn
    |> Controller.put_flash(:error, "Unauthorized access")
    |> Controller.redirect(to: Routes.page_path(conn, :index))
    |> halt()
  end

end
