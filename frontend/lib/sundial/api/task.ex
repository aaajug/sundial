defmodule Sundial.API.TaskAPI do
  use Tesla

  adapter Tesla.Adapter.Httpc
  plug Tesla.Middleware.BaseUrl, "http://backend:4000/api"
  plug Tesla.Middleware.JSON

  # TODO: Refactor to reuse repeating code blocks (inside do block)
  def get_task(client, params) do
    case get(client, "/tasks/" <> params.id) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
    end
  end

  def get_tasks(client), do: get_tasks(client, nil)
  def get_tasks(client, params) do
    url = if params && Map.has_key?(params, :ids) do
      "/tasks?ids=" <> format_ids(params.ids)
    else
      "/tasks"
    end

    case get(client, url) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
        {:error, _} -> nil
    end
  end

  def get_tasks_default_sorting(client) do
    case get(client, "/tasks/default") do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
        {:error, _} -> nil
    end
  end

  def create_task(client, params, list_id, board_id) do
    IO.inspect "createnewtask"
    case post(client, "/boards/"<>board_id<>"/lists/"<>list_id<>"/tasks", params) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
    end
  end

  def edit_task(client, params) do
    case get(client, "/tasks/:id/edit", params) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
    end
  end

  def update_task(client, id, params) do
    case patch(client, "/tasks/" <> Integer.to_string(id), params) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
    end
  end

  def update_task_status(client, id, params) do
    case patch(client, "/tasks/" <> Integer.to_string(id) <> "/update/status", params) do
      {:ok, %{body: body}} -> body
      {_, %{body: body}} -> ""
    end
  end

  def update_positions(client, list_id, params) do
    case post(client, "/lists/"<>list_id<>"/tasks/reorder", params) do
      {:ok, %{body: body}} -> body
      {_, %{body: body}} -> ""
    end
  end

  def delete_task(params) do
    case delete("/tasks/" <> params.id) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
    end
  end

  def get_status do
    case delete("/tasks/progress") do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
    end
  end

  def create_comment(client, board_id, task_id, params) do
    case post(client, "/tasks/"<>Integer.to_string(task_id)<>"/comments", %{data: params}) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
    end
  end

  defp format_ids(ids) do
    if ids, do: Enum.join(ids, ","), else: ""
  end
end
