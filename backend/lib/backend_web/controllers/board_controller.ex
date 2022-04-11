defmodule BackendWeb.BoardController do
  use BackendWeb, :controller

  def show(conn, _params) do
    text(conn, "Boards controller")
  end
end
