defmodule Sundial.API.BoardAPI do
  alias Sundial.API.BaseAPI

  def get_board(client, params) do
    url = "/boards/" <> params.id
    BaseAPI.get_action(client, url)
  end

  def get_boards(client), do: get_boards(client, nil)
  def get_boards(client, params) do
    url = if params do
      "/boards?ids=" <> format_ids(params)
    else
      "/boards"
    end

    BaseAPI.get_action(client, url)
  end

  def get_shared_boards(client) do
    url = "/shared_boards"
    BaseAPI.get_action(client, url)
  end

  def create_board(client, params) do
    url = "/boards"
    BaseAPI.post_action(client, url, params)
  end

  def update_board(client, id, params) do
    url = "/boards/" <> Integer.to_string(id)
    BaseAPI.patch_action(client, url, params)
  end

  def delete_board(client, params) do
    url = "/boards/" <> params.id
    BaseAPI.delete_action(client, url)
  end

  def get_roles do
    url = "/boards/roles"
    BaseAPI.get_action(url)
  end

  defp format_ids(ids) do
    if ids, do: Enum.join(ids, ","), else: ""
  end
end
