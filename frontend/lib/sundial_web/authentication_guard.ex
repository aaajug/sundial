defmodule SundialWeb.AuthenticationGuard do
  use SundialWeb, :controller
  import Plug.Conn, only: [halt: 1]

  alias Phoenix.Controller
  alias Plug.Conn
  alias Pow.Plug
  alias Sundial.API.ClientAPI
  alias Sundial.API.UserAPI

  def init(config), do: config

  def call(conn, config) do
    action = Keyword.get(config, :action)
    is_authenticated = is_authenticated?(conn)

    if !is_authenticated do
      case action do
        :ensure_authenticated ->
          conn
          |> put_flash(:error, "Please login first.")
          |> redirect(to: "/login")
          |> halt

        :redirect_authenticated -> conn
      end
    else
      case action do
        :ensure_authenticated -> conn

        :redirect_authenticated ->
          conn
          |> redirect(to: "/boards")
      end
    end
  end

  defp is_authenticated?(conn) do
    current_user_access_token = Conn.get_session(conn, :current_user_access_token)

    client = ClientAPI.client(current_user_access_token)
    UserAPI.check_authentication(client) == "true"
  end
end
