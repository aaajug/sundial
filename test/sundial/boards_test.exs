defmodule Sundial.BoardsTest do
  use Sundial.DataCase

  alias Sundial.Boards

  describe "boards" do
    alias Sundial.Boards.Board

    import Sundial.BoardsFixtures

    @invalid_attrs %{title: nil, user_id: nil}

    test "list_boards/0 returns all boards" do
      board = board_fixture()
      assert Boards.list_boards() == [board]
    end

    test "get_board!/1 returns the board with given id" do
      board = board_fixture()
      assert Boards.get_board!(board.id) == board
    end

    test "create_board/1 with valid data creates a board" do
      valid_attrs = %{title: "some title", user_id: 42}

      assert {:ok, %Board{} = board} = Boards.create_board(valid_attrs)
      assert board.title == "some title"
      assert board.user_id == 42
    end

    test "create_board/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Boards.create_board(@invalid_attrs)
    end

    test "update_board/2 with valid data updates the board" do
      board = board_fixture()
      update_attrs = %{title: "some updated title", user_id: 43}

      assert {:ok, %Board{} = board} = Boards.update_board(board, update_attrs)
      assert board.title == "some updated title"
      assert board.user_id == 43
    end

    test "update_board/2 with invalid data returns error changeset" do
      board = board_fixture()
      assert {:error, %Ecto.Changeset{}} = Boards.update_board(board, @invalid_attrs)
      assert board == Boards.get_board!(board.id)
    end

    test "delete_board/1 deletes the board" do
      board = board_fixture()
      assert {:ok, %Board{}} = Boards.delete_board(board)
      assert_raise Ecto.NoResultsError, fn -> Boards.get_board!(board.id) end
    end

    test "change_board/1 returns a board changeset" do
      board = board_fixture()
      assert %Ecto.Changeset{} = Boards.change_board(board)
    end
  end

  describe "permissions" do
    alias Sundial.Boards.Permission

    import Sundial.BoardsFixtures

    @invalid_attrs %{board_id: nil, delete: nil, manage_users: nil, read: nil, user_id: nil, write: nil}

    test "list_permissions/0 returns all permissions" do
      permission = permission_fixture()
      assert Boards.list_permissions() == [permission]
    end

    test "get_permission!/1 returns the permission with given id" do
      permission = permission_fixture()
      assert Boards.get_permission!(permission.id) == permission
    end

    test "create_permission/1 with valid data creates a permission" do
      valid_attrs = %{board_id: 42, delete: true, manage_users: true, read: true, user_id: 42, write: true}

      assert {:ok, %Permission{} = permission} = Boards.create_permission(valid_attrs)
      assert permission.board_id == 42
      assert permission.delete == true
      assert permission.manage_users == true
      assert permission.read == true
      assert permission.user_id == 42
      assert permission.write == true
    end

    test "create_permission/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Boards.create_permission(@invalid_attrs)
    end

    test "update_permission/2 with valid data updates the permission" do
      permission = permission_fixture()
      update_attrs = %{board_id: 43, delete: false, manage_users: false, read: false, user_id: 43, write: false}

      assert {:ok, %Permission{} = permission} = Boards.update_permission(permission, update_attrs)
      assert permission.board_id == 43
      assert permission.delete == false
      assert permission.manage_users == false
      assert permission.read == false
      assert permission.user_id == 43
      assert permission.write == false
    end

    test "update_permission/2 with invalid data returns error changeset" do
      permission = permission_fixture()
      assert {:error, %Ecto.Changeset{}} = Boards.update_permission(permission, @invalid_attrs)
      assert permission == Boards.get_permission!(permission.id)
    end

    test "delete_permission/1 deletes the permission" do
      permission = permission_fixture()
      assert {:ok, %Permission{}} = Boards.delete_permission(permission)
      assert_raise Ecto.NoResultsError, fn -> Boards.get_permission!(permission.id) end
    end

    test "change_permission/1 returns a permission changeset" do
      permission = permission_fixture()
      assert %Ecto.Changeset{} = Boards.change_permission(permission)
    end
  end
end
