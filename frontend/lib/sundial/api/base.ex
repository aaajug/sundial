defmodule Sundial.API.BaseAPI do
  use Tesla

  adapter Tesla.Adapter.Httpc
  plug Tesla.Middleware.BaseUrl, "http://backend:4000/api"
  plug Tesla.Middleware.JSON

  alias Sundial.API.ResponseHelper

  def get_action(url) do
    get(url) |> handle_response
  end

  def get_action(client, url) do
    handle_response get(client, url)
  end

  def get_action(client, url, params) do
    handle_response get(client, url, params)
  end

  def post_action(client, url) do
    handle_response post(client, url)
  end

  def post_action(client, url, params) do
    handle_response post(client, url, params)
  end

  def patch_action(client, url) do
    handle_response patch(client, url)
  end

  def patch_action(client, url, params) do
    handle_response patch(client, url, params)
  end

  def delete_action(client, url) do
    handle_response delete(client, url)
  end

  def delete_action(client, url, params) do
    handle_response delete(client, url, params)
  end

  defp handle_response(response) do
    case response do
      {:ok, %{body: body}} -> ResponseHelper.parse(body)
        {_, %{body: body}} -> ""
        {:error, _} -> :error
    end
  end
end
