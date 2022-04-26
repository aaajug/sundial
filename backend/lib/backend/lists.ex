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
    # TODO: clean pipes
    # TODO: create private function for getting target board

    task_query = from(task in Task, order_by: [task.position])
    list_query = from(list in List, order_by: [list.position])
    board = board
            |> Repo.preload([lists: {list_query, [tasks: task_query]}])

    # user_board = user
    #   |> Repo.preload([boards: from(board in Board, where: board.id == ^board_id)])

    # target_board = user_board.boards |> Enum.at(0)

    # IO.inspect target_board |> Repo.preload(:lists) , label: "targetboardlists2"
    # board_lists = target_board


    # t = board_lists.lists |> Enum.at(0)

    board.lists
    # target_board
    # |> Ecto.build_assoc(:lists)
    # |> List.changeset(attrs)
    # |> Ecto.Changeset.put_assoc(:user, user)
    # |> Repo.insert

    # (from user in User, where: user.id == ^user_id)
    #         |> Repo.all
    #         |> Repo.preload(:boards)


    # Repo.all(List)
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
    # IO.inspect %List{} |> List.changeset(attrs), label: "changesetdb"

    # board = (from board in Board, where: board.is == ^board.id)
    #   |> Repo.all

    # get owned boards of user
    # get shared boards of user with manage or write permissions
    # get specific board using board_id
    # build list assoc of specific board
    # create list changeset

    # user_id = user.id

    # user_boards = (from user in User,
    #   where: user.id == ^user_id,
    #   preload: [:boards])
    #     |> Repo.all

    # IO.inspect user_boards, label: "debuguserboards2"

    # user_query = (from user in User,
    #   where: user.id == ^user_id)

    # IO.inspect user_query, label: "userquery"
    # IO.inspect user, label: "userobject"
    # IO.inspect Repo.preload(user, :boards), label: "preloadingcast"

    target_board = Boards.get_board!(board_id)


    # user_board = user
    #   |> Repo.preload([boards: from(board in Board, where: board.id == ^board_id)])

    # target_board = user_board.boards |> Enum.at(0)
    # IO.inspect target_board, label: "targetboarddebug2"


    # user_boards = user_boards
    #   |> Ecto.build_assoc(:shared_boards)

    # IO.inspect user_boards, label: "debuguserboardswithsharedboards"

    #  Ecto.build_assoc(user, :lists, attrs)

    attrs = if attrs do
      attrs
    else
      %{title: "Unnamed list"}
    end

    IO.inspect attrs, label: "attrsdebugger2"
    target_board
    |> Ecto.build_assoc(:lists)
    |> List.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert

    # Ecto.build_assoc(user, :lists, )

    # %List{}
    # |> List.changeset(attrs)
    # |> Repo.insert()
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
        serialized_lists = serialize(lists)

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

  def serialize(%List{} = list) do
    list = list
      |> Repo.preload(:tasks)

    tasks = Enum.map(list.tasks,
      fn task ->
        Tasks.serialize(task)
      end)

    %SerialList{
      id: list.id,
      board_id: list.board_id,
      position: list.position,
      title: list.title,
      owner_id: list.user_id,
      tasks: tasks
    }
  end

  def serialize(lists) do
    lists
      |> Enum.map(
        fn list ->
          serialize(list)
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
