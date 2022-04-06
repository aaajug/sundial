defmodule Sundial.ListsTest do
  use Sundial.DataCase

  alias Sundial.Lists

  describe "lists" do
    alias Sundial.Lists.List

    import Sundial.ListsFixtures

    @invalid_attrs %{board_id: nil, position: nil, title: nil, user_id: nil}

    test "list_lists/0 returns all lists" do
      list = list_fixture()
      assert Lists.list_lists() == [list]
    end

    test "get_list!/1 returns the list with given id" do
      list = list_fixture()
      assert Lists.get_list!(list.id) == list
    end

    test "create_list/1 with valid data creates a list" do
      valid_attrs = %{board_id: 42, position: 42, title: "some title", user_id: 42}

      assert {:ok, %List{} = list} = Lists.create_list(valid_attrs)
      assert list.board_id == 42
      assert list.position == 42
      assert list.title == "some title"
      assert list.user_id == 42
    end

    test "create_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lists.create_list(@invalid_attrs)
    end

    test "update_list/2 with valid data updates the list" do
      list = list_fixture()
      update_attrs = %{board_id: 43, position: 43, title: "some updated title", user_id: 43}

      assert {:ok, %List{} = list} = Lists.update_list(list, update_attrs)
      assert list.board_id == 43
      assert list.position == 43
      assert list.title == "some updated title"
      assert list.user_id == 43
    end

    test "update_list/2 with invalid data returns error changeset" do
      list = list_fixture()
      assert {:error, %Ecto.Changeset{}} = Lists.update_list(list, @invalid_attrs)
      assert list == Lists.get_list!(list.id)
    end

    test "delete_list/1 deletes the list" do
      list = list_fixture()
      assert {:ok, %List{}} = Lists.delete_list(list)
      assert_raise Ecto.NoResultsError, fn -> Lists.get_list!(list.id) end
    end

    test "change_list/1 returns a list changeset" do
      list = list_fixture()
      assert %Ecto.Changeset{} = Lists.change_list(list)
    end
  end
end
