defmodule SundialWeb.PingController do
  use SundialWeb, :controller

  alias Sundial.API

  def show(conn, _params) do

    text(conn, API.ping())
  end
end
