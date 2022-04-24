defmodule Sundial.API.ListAPI do
  use Tesla

  adapter Tesla.Adapter.Httpc
  plug Tesla.Middleware.BaseUrl, "http://backend:4000/api"
  plug Tesla.Middleware.JSON

  plug Tesla.Middleware.Logger

  def get_list(client, id) do
    case get(client, "/lists/" <> id) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
    end
  end

  # def get_lists(client, board_id), do: get_lists(client, nil)
  def get_lists(client, board_id) do
    # url = if params do
    #   "/lists?ids=" <> format_ids(params)
    # else
    #   "/lists"
    # end

    url = "/boards/" <> board_id <> "/lists"

    case get(client, url) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
        {:error, _} -> nil
    end
  end

  def create_list(client, board_id, params) do
    case post(client, "/boards/"<> board_id <> "/lists", params) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
        {:error, error} -> error
    end
  end

  def update_list(client, id, params) do
    IO.inspect params, label: "listupdateparams"
    case patch(client, "/lists/" <> Integer.to_string(id), params) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
    end
  end

  def delete_list(client, id) do
    IO.inspect id, label: "inlist delete API"
    case delete(client, "/lists/" <> id) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
    end
  end

  defp format_ids(ids) do
    if ids, do: Enum.join(ids, ","), else: ""
  end
end
