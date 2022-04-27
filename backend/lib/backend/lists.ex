defmodule Backend.Lists do
  @moduledoc """
  The Lists context.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo
  alias Backend.Boards.Board

  alias Backend.Lists.List
  alias Backend.Tasks.Task
  alias Backend.Lists.SerialList
  alias Backend.Users.User
  alias Backend.Tasks
  alias Backend.Boards

  @doc """
  Returns the list of lists.

  ## Examples

      iex> list_lists()
      [%List{}, ...]

  """
  def list_lists(board, user) do
    task_query = from(task in Task, order_by: [task.position])
    list_query = from(list in List, order_by: [list.position])
    board = board
            |> Repo.preload([lists: {list_query, [tasks: task_query]}])

    board.lists
  end

  @doc """
  Gets a single list.

  Raises `Ecto.NoResultsError` if the List does not exist.

  ## Examples

      iex> get_list!(123)
      %List{}

      iex> get_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_list!(id), do: Repo.get!(List, id)

  @doc """
  Creates a list.

  ## Examples

      iex> create_list(%{field: value})
      {:ok, %List{}}

      iex> create_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_list(user, board_id, attrs \\ %{}) do
    target_board = Boards.get_board!(board_id)

    attrs = if attrs do
      attrs
    else
      %{title: "Unnamed list"}
    end

    target_board
    |> Ecto.build_assoc(:lists)
    |> List.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert
  end

  @doc """
    Updates a list.

    ## Examples

    iex> update_list(list, %{field: new_value})
    {:ok, %List{}}

    iex> update_list(list, %{field: bad_value})
    {:error, %Ecto.Changeset{}}

  """
  def update_list(%List{} = list, attrs) do
    list
    |> List.changeset(attrs)
    |> Repo.update()
  end

  def update_positions(user, insert_index, list_id) do
    insert_index = String.to_integer(insert_index)
    list_id = String.to_integer(list_id)

    list = get_list!(list_id)

    board =
      list
      |> Repo.preload(:board)
      |> Map.fetch!(:board)

    lists = list_lists(board, user)
    list_count = Enum.count(lists)

    new_position =
      cond do
        insert_index == 0 ->
          first_position = get_position_at(lists, 0)
          first_position - 1000

        insert_index == list_count ->
          last_position = get_position_at(lists, - 1)
          last_position + 1000

        true ->
          before_position = get_position_at(lists, insert_index - 1)
          after_position = get_position_at(lists, insert_index)

          after_position = if after_position == before_position + 1 do
            Enum.to_list(insert_index..list_count-1)
            |> Enum.with_index(fn i, multiplier ->
              list = Enum.at(lists, i)
              update_position(list, list.position + (1000*(multiplier+1)))
            end
            )

              after_position + 1000
            else
              after_position
            end

          div(after_position + before_position, 2)
      end

    case update_position(list, new_position) do
      {:ok, _} ->
        lists = list_lists(board, user)
        serialized_lists = serialize(user, lists)

        {:ok, %{board_id: board.id, board_title: board.title, lists: serialized_lists}}

      {:error, _} -> {:error, "Unable to reorder tasks."}
    end
  end

  defp get_position_at(lists, index) do
    lists
    |> Enum.at(index)
    |> Map.fetch!(:position)
  end

  def update_position(%List{} = list, position) do
    list
      |> List.changeset(%{"position" => position})
      |> Repo.update()
  end

  @doc """
  Deletes a list.

  ## Examples

      iex> delete_list(list)
      {:ok, %List{}}

      iex> delete_list(list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_list(%List{} = list) do
    Repo.delete(list)
  end

  def serialize(user, %List{} = list) do
    list = list
      |> Repo.preload(:tasks)

    tasks = Enum.map(list.tasks,
      fn task ->
        Tasks.serialize(user, task)
      end)

    role = Boards.permission(user.id, list.board_id) |> Map.fetch!(:role)

    actions_allowed = role in ["manager", "contributor"]
    delete_allowed =  role == "manager"

    %SerialList{
      id: list.id,
      board_id: list.board_id,
      position: list.position,
      title: list.title,
      owner_id: list.user_id,
      tasks: tasks,
      actions_allowed: actions_allowed,
      delete_allowed: delete_allowed
    }
  end

  def serialize(user, lists) do
    lists
      |> Enum.map(
        fn list ->
          serialize(user, list)
        end
      )
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking list changes.

  ## Examples

      iex> change_list(list)
      %Ecto.Changeset{data: %List{}}

  """
  def change_list(%List{} = list, attrs \\ %{}) do
    List.changeset(list, attrs)
  end
end
