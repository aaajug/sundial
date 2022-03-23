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
    Repo.all(from task in Task,
             order_by: [desc: task.completed_on,
                        asc: task.status,
                        asc: task.deadline,
                        desc: task.updated_at])
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

    is_overdue = if task.deadline && task.completed_on == nil && task.status != 3 do
                   NaiveDateTime.compare(NaiveDateTime.local_now, task.deadline) == :gt
                 else
                   false
                 end

    [completed_on,
    [completed_on_date,
    completed_on_time,
    completed_on_time_hour,
    completed_on_time_minute]] = if task.status == 4 do
                                   [format_datetime(task.completed_on), parse_date(task.completed_on)]
                                 else
                                   [nil, [nil, nil , nil, nil]]
                                 end

    deadline = format_datetime(task.deadline)
    [deadline_date, deadline_time, deadline_time_hour, deadline_time_minute] = parse_date(task.deadline)

    %SerialTask{
      id: task.id,
      description: task.description,
      details: task.details,
      deadline: deadline,
      completed_on: completed_on,
      status: status_name,
      status_desc: status_description,
      is_overdue: is_overdue,
      deadline_parsed: %{date: deadline_date, time: deadline_time, hour: deadline_time_hour, minute: deadline_time_minute},
      completed_on_parsed: %{date: completed_on_date, time: completed_on_time, hour: completed_on_time_hour, minute: completed_on_time_minute}
    }
  end

  def serialize(%Task{} = task) do
    serialize_task(task)
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

  defp parse_date(nil), do: [nil, nil, nil, nil]
  defp parse_date(datetime) do
    time = datetime |> NaiveDateTime.to_time
    [datetime |> NaiveDateTime.to_date, time, time.hour, time.minute]
  end
end
