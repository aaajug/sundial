defmodule Sundial.API.TaskAPI do
  use Tesla

  adapter Tesla.Adapter.Httpc
  plug Tesla.Middleware.BaseUrl, "http://backend:4000/api"
  plug Tesla.Middleware.JSON

  # TODO: Refactor to reuse repeating code blocks (inside do block)
  def get_task(params) do
    case get("/tasks/" <> params.id) do
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

  def get_tasks_default_sorting() do
    case get("/tasks/default") do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
        {:error, _} -> nil
    end
  end

  def create_task(params) do
    case post("/tasks", params) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
    end
  end

  def edit_task(params) do
    case get("/tasks/:id/edit", params) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
    end
  end

  def update_task(id, params) do
    case patch("/tasks/" <> Integer.to_string(id), params) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
    end
  end

  def update_task_status(id, params) do
    case patch("/tasks/" <> Integer.to_string(id) <> "/update/status", params) do
      {:ok, %{body: body}} -> body
      {_, %{body: body}} -> ""
    end
  end

  def update_positions(params) do
    case post("/tasks/reorder", params) do
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

  defp format_ids(ids) do
    if ids, do: Enum.join(ids, ","), else: ""
  end
end
