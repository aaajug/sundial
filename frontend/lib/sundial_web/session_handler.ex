defmodule SundialWeb.SessionHandler do
  alias Plug.Conn

  def set_current_user(conn, user) do
    # %{"email" => email, "access_token" => access_token}
    Conn.put_session(conn, :current_user, user["access_token"])
  end

  def get_current_user(conn) do
    Conn.get_session(conn, :current_user)
  end

  def destroy_current_user(conn) do
    Conn.delete_session(conn, :current_user)
  end
end
