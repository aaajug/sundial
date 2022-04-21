defmodule SundialWeb.Redirect do
  use SundialWeb, :controller

  alias Sundial.API.UserAPI
  alias Sundial.API.ClientAPI

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    if is_authenticated?(conn) do
      # IO.inspect get_session(conn, :current_user_access_token), label: "conndbsession"
      conn
    else
      redirect(conn, to: "/login")
    end
    # IO.inspect is_authenticated?(conn), label: "is_auth? 8"
    # IO.inspect conn, label: "redirect-conn"
    # is_authenticated = UserAPI.authenticate

    # conn
    # case assigns do
    #   %{user_id: user_id} when not in_nil(user_id) ->
    #      redirect(conn, to: Routes.your_page_path(conn, :action))
    #   _other ->
    #      conn # do nothing
    # end
  end

  defp is_authenticated?(conn) do
    current_user_access_token = get_session(conn, :current_user_access_token)

    client = ClientAPI.client(current_user_access_token)

    # IO.inspect current_user_access_token, label: "current_user_access_tokendb2"
    # IO.inspect client, label: "clientdb"

    UserAPI.check_authentication(client) == "true"

  end

  # defp current_user_access_token(conn) do
  #   get_session(conn, :current_user_access_token)
  # end
end
