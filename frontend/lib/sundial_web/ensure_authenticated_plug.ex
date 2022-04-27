defmodule SundialWeb.EnsureAuthenticated do
  use SundialWeb, :controller
  import Plug.Conn, only: [halt: 1]

  alias Phoenix.Controller
  alias Plug.Conn
  alias Pow.Plug
  alias Sundial.API.ClientAPI
  alias Sundial.API.UserAPI

  def init(config), do: config

  def call(conn, _params) do
    if !is_authenticated?(conn) do
      conn
      |> put_flash(:error, "Please login first.")
      |> redirect(to: "/login")
    end

    conn
  end

  defp is_authenticated?(conn) do
    current_user_access_token = Conn.get_session(conn, :current_user_access_token)

    client = ClientAPI.client(current_user_access_token)
    UserAPI.check_authentication(client) == "true"
  end
end
