defmodule SundialWeb.Redirect do
  use SundialWeb, :controller

  alias Sundial.API.UserAPI
  alias Sundial.API.ClientAPI

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    if is_authenticated?(conn) do
      conn
    else
      redirect(conn, to: "/login")
    end
  end

  defp is_authenticated?(conn) do
    current_user_access_token = get_session(conn, :current_user_access_token)
    client = ClientAPI.client(current_user_access_token)

    UserAPI.check_authentication(client) == "true"
  end
end
