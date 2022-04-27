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
    conn = destroy_current_user(conn)

    {
      {:error, error},
      {:success_info, success_info},
      {:data, data}
    } = UserAPI.create_session(user_params)

    if success_info do
      conn
      |> put_session("success_info", success_info)
      |> put_session("current_user_access_token", data["access_token"])
      |> put_session("current_user_email", data["email"])
      |> redirect(to: "/boards")
    else
      conn
      |> put_session("error", error)
      |> redirect(to: "/login")
    end
  end

  def destroy_current_user(conn) do
    conn
      |> assign(:current_user_access_token, "")
      |> delete_session("current_user_access_token")
      |> delete_session("current_user_email")
      |> delete_session("success_info")
      |> delete_session("error")
  end
end
