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
  def list_lists(user, board_id) do
    # TODO: clean pipes
    # TODO: create private function for getting target board

    query = from(task in Task, order_by: [task.position, task.updated_at, task.inserted_at])
    board = Boards.get_board!(String.to_integer(board_id))
            |> Repo.preload([lists: [tasks: query]])

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
