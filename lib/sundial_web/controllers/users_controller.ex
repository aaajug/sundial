defmodule SundialWeb.UsersController do
  use SundialWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
