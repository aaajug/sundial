defmodule Sundial.API.UserAPI do
  use Tesla

  adapter Tesla.Adapter.Httpc

  plug Tesla.Middleware.BaseUrl, "http://backend:4000/api"
  plug Tesla.Middleware.JSON

  alias Sundial.API.ResponseHelper

  def check_authentication(nil), do: false
  def check_authentication(client) do
    case get(client,"/session/authenticated") do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
    end
  end

  def create_user(params) do
    case post("/registration", params) do
      {:ok, %{body: body}} -> ResponseHelper.parse(body)
        {_, %{body: body}} -> ""
    end
  end

  def create_session(params) do
    case post("/session", params) do
      {:ok, %{body: body}} -> ResponseHelper.parse(body)
        {_, %{body: body}} -> ""
    end
  end

  def destroy_session() do
    case delete("/session") do
      {:ok, %{body: body}} -> ResponseHelper.parse(body)
        {_, %{body: body}} -> ""
    end
  end

  # def client(access_token) do
  #   middleware = [
  #     {Tesla.Middleware.Headers, [{"authorization", access_token }]}
  #   ]

  #   Tesla.client(middleware)
  # end
end
