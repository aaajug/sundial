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
            |> Repo.preload([boards: from(board in Board, order_by: [board.id])])
  end

  def list_shared_boards(user) do
    user_id = user.id

    user
      |> Repo.preload([shared_boards: from(board in Board, where: board.user_id != ^user_id, order_by: [board.id])])
      |> Map.fetch!(:shared_boards)
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
  def get_board(user, id) do
    query = from(board in Board, where: board.id == ^id)

    user_boards =
      user
      |> Repo.preload([boards: query])
      |> Repo.preload([shared_boards: query])

    boards = user_boards.boards ++ user_boards.shared_boards

    boards
    |> Enum.at(0)
  end

  @doc """
  Creates a board.

  ## Examples

      iex> create_board(%{field: value})
      {:ok, %Board{}}

      iex> create_board(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_board(user, board_params, permissions) do
    board = user
    |> Ecto.build_assoc(:boards)
    |> Board.changeset(board_params)
    |> Repo.insert!

    set_board_permissions(board, permissions)
    set_board_permissions(board, [{"board_owner_role", %{"email" => user.email, "remove" => "", "role" => "manager"}}])

    {:ok, get_board!(board.id)}
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
    set_board_permissions(board, permissions)

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

  def serialize(user, %Board{} = board) do
    users = serialize_permissions(board)

    # update, delete only for managers
    role = permission(user.id, board.id)
        |> Map.fetch!(:role)

    actions_allowed = role == "manager"
    create_allowed = role in ["manager", "contributor"]

    %SerialBoard{
      id: board.id,
      title: board.title,
      owner_id: board.user_id,
      users: users,
      actions_allowed: actions_allowed,
      create_allowed: create_allowed
    }
  end

  def serialize(user, boards) do
    boards
      |> Enum.map(
        fn board ->
          serialize(user, board)
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
            %{email: user.email,
              role: permission.role}
          end)
  end

  def permission(user_id, board_id) do
    from(permission in Permission,
      where: permission.user_id == ^user_id
             and permission.board_id == ^board_id)
      |> Repo.one
  end

  def set_board_permissions(board, permissions) do
    if permissions do
      board_id = board.id
      permissions
        |> Enum.each(fn permission ->
            {_, %{"email" => email, "remove" => remove,"role" => role}} = permission
            user = Users.get_user_by_email(String.trim(email))
            if user do
              set_user_board_permission(user, board, email, role, remove)
            else
              # return non-existing users
            end
          end)
    end
  end

  defp set_user_board_permission(user, board, email, role, remove) do
    if remove == "true" && user.id != board.user_id do
      user_id = user.id
      board_id = board.id

      (from permission in Permission,
        where: permission.user_id == ^user_id
               and permission.board_id == ^board_id)
        |> Repo.one
        |> Repo.delete
    else
              role = if user.id == board.user_id do
                        "manager"
                    else
                        role
                    end

              permission_record = permission(user.id, board.id)

              attrs = %{
                user_id: user.id,
                board_id: board.id,
                role: role
              }

              if permission_record do
                permission_record
                |> Permission.changeset(attrs)
                |> Repo.update()
              else
                %Permission{}
                |> Permission.changeset(attrs)
                |> Repo.insert!()
              end
            end
  end
end
