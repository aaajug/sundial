defmodule Sundial.API.ListAPI do
  use Tesla

  adapter Tesla.Adapter.Httpc
  plug Tesla.Middleware.BaseUrl, "http://backend:4000/api"
  plug Tesla.Middleware.JSON

  def get_list(params) do
    case get("/lists/" <> params.id) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
    end
  end

  def get_lists, do: get_lists(nil)
  def get_lists(params) do
    url = if params do
      "/lists?ids=" <> format_ids(params)
    else
      "/lists"
    end

    case get(url) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
        {:error, _} -> nil
    end
  end

  def create_list(client, board_id, params) do
    case post("/boards/"<> board_id <> "/lists", params) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
        {:error, error} -> error
    end
  end

  def update_list(id, params) do
    case patch("/lists/" <> Integer.to_string(id), params) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
    end
  end

  def delete_list(params) do
    IO.inspect "inlist delete API"
    case delete("/lists/" <> params.id) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
    end
  end

  defp format_ids(ids) do
    if ids, do: Enum.join(ids, ","), else: ""
  end
end
