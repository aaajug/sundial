defmodule SundialWeb.PingController do
  use SundialWeb, :controller

  alias Sundial.API

  def show(conn, _params) do
    text(conn, API.ping())
  end

  # def create_task(conn, params) do
  #   text(conn, API.send(params))
  # end
end
