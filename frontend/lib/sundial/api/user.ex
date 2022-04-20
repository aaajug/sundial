defmodule Sundial.API.UserAPI do
  use Tesla

  adapter Tesla.Adapter.Httpc

  plug Tesla.Middleware.BaseUrl, "http://backend:4000/api"
  plug Tesla.Middleware.JSON

  alias Sundial.API.ResponseHelper

  plug Tesla.Middleware.Logger

  def get_current_user() do
    # case get("/tasks/" <> params.id) do
    #   {:ok, %{body: body}} -> body
    #     {_, %{body: body}} -> ""
    # end
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
end
