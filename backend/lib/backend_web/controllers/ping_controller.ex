defmodule BackendWeb.PingController do
  use BackendWeb, :controller

  def show(conn, _params) do
    text(conn, "pong")
  end
end
