defmodule BackendWeb.ListController do
  use BackendWeb, :controller

  def show(conn, _params) do
    text(conn, "Lists")
  end
end
