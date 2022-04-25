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
  def get_board(user, id) do
    user
    |> Repo.preload([boards: from(board in Board, where: board.id == ^id)])
    |> Map.fetch!(:boards)
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
  # def create_board(attrs \\ %{}) do
  def create_board(user, board_params, permissions) do
    # attrs = if attrs do
    #   Map.put(attrs, "user_id", attrs["user_id"])
    # end

    # IO.inspect(attrs, label: "attrsdb5")

    # IO.inspect %Board{} |> Board.changeset(attrs), label: "changsetboard8"

    # %Board{}
    # |> Board.changeset(attrs)
    # |> Repo.insert()

    # %Board

    IO.inspect board_params, label: "boardparamsbeforeinsert"

    board = user
    |> Ecto.build_assoc(:boards)
    |> Board.changeset(board_params)
    |> Repo.insert!

    # board = Repo.insert!(board)

    # board_owner_role = %{"board_owner_role" => %{"email" => user.email, "role" => "manager"}}
    # permissions = if permissions == nil || permissions == [] do
    #   [board_owner_role]
    # else
    #   [board_owner_role | permissions]
    # end

    set_board_permissions(board, permissions)
    set_board_permissions(board, [{"board_owner_role", %{"email" => user.email, "remove" => "", "role" => "manager"}}])

    {:ok, get_board!(board.id)}

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
    # IO.inspect attrs
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

  def permission(user_id, board_id) do
    # def is_update_permission?(user_id, board_id, role) do
      IO.inspect user_id, label: "useridperm"
      IO.inspect board_id, label: "boardidperm"
    from(permission in Permission,
      where: permission.user_id == ^user_id
             and permission.board_id == ^board_id)
      |> Repo.one

    # permission.role != role
  end

  def set_board_permissions(board, permissions) do
    IO.inspect board, label: "boardrepoinsertboard"
    IO.inspect permissions, label: "permissionsinsetboard5"

    if permissions do
      IO.inspect "insideherepermissions"
      board_id = board.id
      permissions
        |> Enum.each(fn permission ->
          IO.inspect permission, label: "permissionloop3"
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
