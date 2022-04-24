defmodule Backend.Boards do
  @moduledoc """
  The Boards context.
  """

  import Ecto.Query, warn: false

  alias Backend.Repo
  alias Backend.Users
  alias Backend.Boards.Board
  alias Backend.Boards.Permission
  alias Backend.Boards.SerialBoard
  alias Backend.Users.User

  @doc """
  Returns the list of boards.

  ## Examples

      iex> list_boards()
      [%Board{}, ...]

  """
  def list_boards(user_id) do

    load = (from user in User, where: user.id == ^user_id)
            |> Repo.all
            |> Repo.preload(:boards)

          # Repo.all(User) |> Repo.preload(:boards)

    # IO.inspect load, label: "loadprint"

    # IO.inspect(IEx.Info.info load)
    # IO.inspect Enum.at(load, 0), label: "first element"
    # i load

    # IO.inspect user_id, label: "useriddebug"
    # t = from(board in Board, where: board.user_id == ^user_id)
    #   |> Repo.all(User)
    #   |> Repo.preload(:boards)

    # Repo.all(Board)
  end

  @doc """
  Gets a single board.

  Raises `Ecto.NoResultsError` if the Board does not exist.

  ## Examples

      iex> get_board!(123)
      %Board{}

      iex> get_board!(456)
      ** (Ecto.NoResultsError)

  """
  def get_board!(id), do: Repo.get!(Board, id)
  # def get_board(user, id) do
  #   (from board in Board,
  #     where: board.user_id == ^user.id and borad)
  # end

  @doc """
  Creates a board.

  ## Examples

      iex> create_board(%{field: value})
      {:ok, %Board{}}

      iex> create_board(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # def create_board(attrs \\ %{}) do
  def create_board(board) do
    # attrs = if attrs do
    #   Map.put(attrs, "user_id", attrs["user_id"])
    # end

    # IO.inspect(attrs, label: "attrsdb5")

    # IO.inspect %Board{} |> Board.changeset(attrs), label: "changsetboard8"

    # %Board{}
    # |> Board.changeset(attrs)
    # |> Repo.insert()

    # %Board
    Repo.insert!(board)

    # %Board{}
    # |> attrs
    # |> Repo.insert()
  end

  @doc """
  Updates a board.

  ## Examples

      iex> update_board(board, %{field: new_value})
      {:ok, %Board{}}

      iex> update_board(board, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_board(%Board{} = board, permissions, attrs) do
    board_id = board.id

    IO.inspect permissions, label: "permissionsprint"

    # TOOD: modularize
    # TODO: catch non-existing users
    if permissions do
      permissions
      |> Enum.each(fn permission ->
          {_, %{"email" => email, "role" => role}} = permission
          user = Users.get_user_by_email(email)
          if user && is_non_existing_permission?(user.id, board_id) do
            role = if user.id == board.user_id do
                      "manager"
                   else
                      role
                   end

            permission = %Permission{
              user_id: user.id,
              board_id: board_id,
              role: role
            }

            permission
            |> Permission.changeset(attrs)
            |> Repo.insert()
          else
            # return non-existing users
          end
        end)
    end

    board
    |> Board.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a board.

  ## Examples

      iex> delete_board(board)
      {:ok, %Board{}}

      iex> delete_board(board)
      {:error, %Ecto.Changeset{}}

  """
  def delete_board(%Board{} = board) do
    Repo.delete(board)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking board changes.

  ## Examples

      iex> change_board(board)
      %Ecto.Changeset{data: %Board{}}

  """
  def change_board(%Board{} = board, attrs \\ %{}) do
    Board.changeset(board, attrs)
  end

  # def serialize(%Board{} = board), do: serialize(board)
  def serialize(%Board{} = board) do

    users = serialize_permissions(board)

    %SerialBoard{
      id: board.id,
      title: board.title,
      owner_id: board.user_id,
      users: users
    }
  end

  def serialize(boards) do
    boards
      |> Enum.map(
        fn board ->
          serialize(board)
        end
      )
  end

  def serialize_permissions(board) do
    users = %{}

    board
      |> Repo.preload(:permissions)
      |> Map.fetch!(:permissions)
      |> Enum.map(fn permission ->
            user = Users.get_user!(permission.user_id)
            # users = Map.put(users, user.email, permission.role)
            %{email: user.email,
              role: permission.role}
          end)

    # users
  end

  def is_non_existing_permission?(user_id, board_id) do
    permission = from(permission in Permission,
      where: permission.user_id == ^user_id
             and permission.board_id == ^board_id)
      |> Repo.one

    permission == nil
  end
end
