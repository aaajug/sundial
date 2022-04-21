defmodule SundialWeb.Redirect do
  use SundialWeb, :controller

  alias Sundial.API.UserAPI

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    IO.inspect conn, label: "redirect-conn"
    is_authenticated = UserAPI.authenticate

    conn
    # case assigns do
    #   %{user_id: user_id} when not in_nil(user_id) ->
    #      redirect(conn, to: Routes.your_page_path(conn, :action))
    #   _other ->
    #      conn # do nothing
    # end
  end
end
