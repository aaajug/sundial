defmodule BackendWeb.UserController do
  use BackendWeb, :controller

  def show(conn, _params) do
    text(conn, "Users")
  end
end
