defmodule Sundial.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias Sundial.Repo

  alias Sundial.Tasks.Task
  alias Sundial.Tasks.SerialTask

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Repo.all(from task in Task, order_by: [asc: task.status, desc: task.updated_at])
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  @doc """
  Returns a SerialTask struct containing details of a task
  task:
    id
    description
    details
    deadline
    completed_on

    status
    status_desc

    is_overdue
  """
  def serialize_task(%Task{} = task) do
    status_id = if task.status == 0 || task.status == nil do
                  1
                else
                  task.status
                end

    [{status_name, status_description}] = Repo.all(from s in "status", where: s.id == ^status_id, select: {s.name, s.description})

    %SerialTask{
      id: task.id,
      description: task.description,
      details: task.details,
      deadline: format_datetime(task.deadline),
      completed_on: format_datetime(task.completed_on),
      status: status_name,
      status_desc: status_description,
      is_overdue: false
    }
  end

  @doc """
  Return a list of map objects corresponding to tasks
  """
  def serialize(tasks) do
    Enum.map(tasks, fn(task) -> serialize_task(task) end)
  end

  # private

  defp format_datetime(nil), do: nil
  defp format_datetime(datetime) do
    Calendar.strftime(datetime, "%d %b %Y | %H:%M")
  end
end
