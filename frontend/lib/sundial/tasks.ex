defmodule Sundial.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  # import Sundial.Progress
  alias Sundial.Repo

  alias Sundial.Tasks.Task
  alias Sundial.Tasks.SerialTask
  # alias Sundial.Progress.Status
  alias Sundial.Progress

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    # Repo.all(from task in Task,
    #          order_by: [desc: task.completed_on,
    #                     asc: task.status,
    #                     asc: task.deadline,
    #                     desc: task.updated_at])

    Repo.all(from task in Task,
             order_by: [asc: task.deadline,
                        asc: task.status,
                        desc: task.completed_on,
                        desc: task.updated_at])
  end

  def list_tasks(task_ids) do
    from(task in Task, where: task.id in ^task_ids)
      |> Repo.all()
  end


  def list_tasks_by_position do
    from(task in Task, order_by: [task.position, task.updated_at, task.inserted_at])
      |> Repo.all()
  end

  def initialize_positions do
    list_tasks()
      |> Enum.with_index
      |> Enum.map(fn({task, position}) -> update_position(task, position * 1000) end)
  end

  def update_position(%Task{} = task, position) do
    task
      |> Task.changeset(%{"position" => position})
      |> Repo.update()
  end

  def get_position(task_id) do
    from(t in Task,
      where: t.id == ^task_id,
      select: t.position)
        |> Repo.all()
  end

  # Deprecated in favor the drag&drop feature
  # def find_insert_position(%Task{} = task, _current_index, moves) do
  #   # handle extremes (no before or after)

  #   task_id = task.id
  #   indices = from(t in Task,
  #                   select: {t.id, (row_number() |> over(order_by: t.position))},
  #                   where: t.status == ^task.status)
  #                   |> Repo.all()


  #    {{task_id, current_index}, list_index} =
  #     indices
  #       |> Enum.with_index
  #       |> Enum.find(fn x -> match?({{^task_id, _}, _}, x) end)


  #   # find current row_number of task
  #   # current_index = from(t in Task,
  #   #                 where: t.id == ^task.id,
  #   #                 select: row_number()
  #   #                   |> over(order_by: t.position))

  #   # calculate new index based on moves
  #   # new_index = String.to_integer(current_index) + String.to_integer(moves)
  #   new_index = current_index + moves

  #   before_index = list_index + moves - 1
  #   after_index = list_index + moves

  #   {before_task_id, _} = if before_index >= 0 do
  #                           Enum.at(indices, before_index)
  #                         else
  #                           Enum.at(indices, 0)
  #                         end

  #   {after_task_id, _} = if i = Enum.at(indices, after_index) do
  #                               i
  #                        else
  #                         {nil, nil}
  #                             end

  #   [position_before] = if before_index >= 0 do
  #                         get_position(before_task_id)
  #                       else
  #                         [List.first(get_position(before_task_id)) - 1000]
  #                       end

  #   [position_after] = if after_task_id do
  #                       get_position(after_task_id)
  #                     else
  #                       [position_before + 1000]
  #                     end

  #   # get position of record before and after new position
  # #   position_before = from(t in Task,
  # #   select: (nth_value(t.position, ^new_index) |> over(partition_by: t.status, order_by: t.position))
  # #   )
  # #   |> Repo.all()
  # #   |> Enum.reject(fn x -> !x end)
  # #   |> Enum.max()

  # #  position_after = from(t in Task,
  # #    select: (nth_value(t.position, ^new_index+1) |> over(partition_by: t.status, order_by: t.position))
  # #    )
  # #    |> Repo.all()
  # #    |> Enum.reject(fn x -> !x end)
  # #    |> Enum.max()

  #   # c = from(t in Task,
  #   #  select: {t.position |> over(order_by: t.position)}
  #   #  )
  #   #  |> Repo.all()

  #   # calculate mid for new position
  #   cond do
  #     position_before -> mid = Integer.floor_div(position_before + position_after, 2)
  #                        update_position(task, mid)
  #                       #  {:error, "Can't execute action."}
  #     true -> {:ok, "Retain original position"} # task card already at the end of the list, no need to update
  #   end
  # end

  # Updates positions of tasks in order of the given list of IDs
  def update_positions(list) do
    initial_positions = []
    result = true

    updated_tasks =
      list
        |> Enum.with_index(
            fn id, new_position ->
              task = get_task!(id)

              initial_positions = [ %{id: id, attr: %{"position" => task.position}} | initial_positions]

              try do
                result = update_position(task, new_position * 1000)
                if !update_position(task, new_position * 1000) do
                  throw(:break)
                else
                  result
                end
              catch
                :break -> result = :broken
                result
              end
            end
          )

    case result do
      :broken ->
        rollback(initial_positions)
        {:error, "Failed to reorder tasks. Doing a rollback."}
      true -> {:ok, updated_tasks, "Tasks reordered"}
    end
  end

  def rollback(rollback_data) do
    rollback_data
      |> Enum.map(
        fn obj ->
          task = get_task!(obj.id)

          update_task(task, obj.attr)
        end
      )
  end

  def is_all_position_nil? do # need to check if all tasks have no position, if so, initialize positions
    distinct_positions = Task
                          |> select([task], task.position)
                          |> distinct(true)
                          |> Repo.all()

    if distinct_positions == [nil], do: true
  end


  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.query = from si in subquery(current_index), where: si.id == ^task.id

  #  query

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
    attrs = cond do
              Map.has_key?(attrs, "status") && (attrs["status"] != "4" && attrs["status"] != 4 ) ->
                Map.put(attrs, "completed_on", nil)

              Map.has_key?(attrs, :status) && (attrs.status != "4" && attrs.status != 4) ->
                Map.put(attrs, :completed_on, nil)

              !Map.has_key?(attrs, "status") && !Map.has_key?(attrs, :status) && task.status != 4 && Map.has_key?(attrs, "completed_on") ->
                Map.put(attrs, "completed_on", nil)

              !Map.has_key?(attrs, "status") && !Map.has_key?(attrs, :status) && task.status != 4 && Map.has_key?(attrs, :completed_on) ->
                Map.put(attrs, :completed_on, nil)

              true -> attrs
            end

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
  def serialize_task(%Task{} = task, index) do
    status_id = if task.status == 0 || task.status == nil do
                  1
                else
                  task.status
                end

    # [{status_name, status_description}] = Repo.all(from s in "status", where: s.id == ^status_id, select: {s.name, s.description})
    task_status = Progress.list_status() |> Enum.filter(fn status -> status.id == status_id end) |> List.first

    is_overdue = if task.deadline && (task.completed_on == nil || (task.completed_on != nil && task.status != 4)) && task.status != 3 do
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
      details_plaintext: task.details_plaintext,
      deadline: deadline,
      completed_on: completed_on,
      status: task_status.name,
      status_desc: task_status.description,
      is_overdue: is_overdue,
      deadline_parsed: %{date: deadline_date, time: deadline_time, hour: deadline_time_hour, minute: deadline_time_minute},
      completed_on_parsed: %{date: completed_on_date, time: completed_on_time, hour: completed_on_time_hour, minute: completed_on_time_minute},
      position: task.position,
      index: index
    }
  end

  def serialize(%Task{} = task) do
    serialize_task(task, nil)
  end
  @doc """
  Return a list of map objects corresponding to tasks
  """
  def serialize(tasks) do
    tasks
      |> Enum.with_index
      |> Enum.map(fn({task, index}) -> serialize_task(task, index) end)

      # Enum.map(tasks, fn(task) -> serialize_task(task,) end)
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

  alias Sundial.Tasks.Comment

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments do
    Repo.all(Comment)
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end
end