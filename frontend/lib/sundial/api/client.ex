defmodule Sundial.API.ClientAPI do
  use Tesla

  def client(access_token) do
    middleware = [
      {Tesla.Middleware.Headers, [{"authorization", access_token }]}
    ]

    Tesla.client(middleware)
  end
end
