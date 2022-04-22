defmodule SundialWeb.SessionHandler do
  use SundialWeb, :controller
  # import Phoenix.LiveView.Controller

  # alias Plug.Conn
  alias Sundial.API.UserAPI

  def fetch_current_user_access_token(conn), do: fetch_current_user_access_token(conn, nil)
  def fetch_current_user_access_token(conn, _params) do
    get_session(conn, "current_user_access_token")
  end

  def set_current_user(conn, %{"user" => user_params}) do
    # %{"email" => email, "access_token" => access_token}
    # Conn.put_session(conn, :current_user, user["access_token"])
    # IO.inspect conn, label: "sessionhandlerconn"

    destroy_current_user(conn)

    # IO.inspect "debugging session handler"

    {
      {:error, error},
      {:success_info, success_info},
      {:data, data}
    } = UserAPI.create_session(user_params)

    # session = %{"error" => error, "success_info" => success_info, "data" => data}

    # conn = Conn.put_session(conn, :user, [name: "arianne", email: "arianne@yahoo.com"])
    # user = Conn.get_session(conn, :user)

    if success_info do
      # Conn.put_session(conn, :current_user_acces_token, user_params["access_token"])
      # Conn.put_session(conn, :current_user_email, user_params["email"])

      conn
      |> put_session("success_info", success_info)
      |> put_session("current_user_access_token", data["access_token"])
      |> put_session("current_user_email", data["email"])
      |> redirect(to: "/boards")
    else
      conn
      |> put_session("error", error)
      |> redirect(to: "/login")
      # |> live_render(SundialWeb.UserLive.Registration, session: session)
    end
  end

  def destroy_current_user(conn) do
    conn
      |> delete_session("current_user_access_token")
      |> delete_session("current_user_email")
      |> delete_session("success_info")
      |> delete_session("error")
    # Conn.delete_session(conn, :current_user)
  end
end
