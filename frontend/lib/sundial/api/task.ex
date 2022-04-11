defmodule Sundial.API.TaskAPI do
  use Tesla
  plug Tesla.Middleware.BaseUrl, "http://localhost:4040/api"
  plug Tesla.Middleware.JSON

  # TODO: Refactor to reuse repeating code blocks (inside do block)
  def get_task(params) do
    case get("/tasks/" <> params.id) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
    end
  end

  def get_tasks, do: get_tasks(nil)
  def get_tasks(params) do
    case get("/tasks?ids=" <> format_ids(params)) do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
    end
  end

  def get_tasks_default_sorting() do
    case get("/tasks/default") do
      {:ok, %{body: body}} -> body
        {_, %{body: body}} -> ""
    end
  end

  def create_task(params) do
    case post("/tasks/create", params) do
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

  def update_task(params) do
    case post("/tasks/:id", params) do
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
