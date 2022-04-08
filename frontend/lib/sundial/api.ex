defmodule Sundial.API do
  use Tesla
  plug Tesla.Middleware.BaseUrl, "http://localhost:4040/api"
  plug Tesla.Middleware.JSON

  def ping() do
    case get("/ping") do
    {:ok, %{body: body}} -> body
      {_, %{body: body}} -> ""
    end
  end
end
