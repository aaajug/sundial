defmodule Sundial.API.BoardAPI do
  use Tesla

  adapter Tesla.Adapter.Httpc
  plug Tesla.Middleware.BaseUrl, "http://backend:4000/api"
  plug Tesla.Middleware.JSON

  def get_board(client, params) do
    case get(client, "/boards/" <> params.id) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
    end
  end

  def get_boards(client), do: get_boards(client, nil)
  def get_boards(client, params) do
    url = if params do
      "/boards?ids=" <> format_ids(params)
    else
      "/boards"
    end

    case get(client, url) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
        {:error, _} -> nil
    end
  end

  def create_board(client, params) do
    IO.inspect params, label: "paramsdbcre"
    case post(client, "/boards", params) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
    end
  end

  def update_board(id, params) do
    case patch("/boards/" <> Integer.to_string(id), params) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
    end
  end

  def delete_board(params) do
    IO.inspect "inboard delete API"
    case delete("/boards/" <> params.id) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
    end
  end

  def get_roles do
    case get("/boards/roles") do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
    end
  end

  defp format_ids(ids) do
    if ids, do: Enum.join(ids, ","), else: ""
  end
end
