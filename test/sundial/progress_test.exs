defmodule Sundial.ProgressTest do
  use Sundial.DataCase

  alias Sundial.Progress

  describe "status" do
    alias Sundial.Progress.Status

    import Sundial.ProgressFixtures

    @invalid_attrs %{description: nil, name: nil}

    test "list_status/0 returns all status" do
      status = status_fixture()
      assert Progress.list_status() == [status]
    end

    test "get_status!/1 returns the status with given id" do
      status = status_fixture()
      assert Progress.get_status!(status.id) == status
    end

    test "create_status/1 with valid data creates a status" do
      valid_attrs = %{description: "some description", name: "some name"}

      assert {:ok, %Status{} = status} = Progress.create_status(valid_attrs)
      assert status.description == "some description"
      assert status.name == "some name"
    end

    test "create_status/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Progress.create_status(@invalid_attrs)
    end

    test "update_status/2 with valid data updates the status" do
      status = status_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %Status{} = status} = Progress.update_status(status, update_attrs)
      assert status.description == "some updated description"
      assert status.name == "some updated name"
    end

    test "update_status/2 with invalid data returns error changeset" do
      status = status_fixture()
      assert {:error, %Ecto.Changeset{}} = Progress.update_status(status, @invalid_attrs)
      assert status == Progress.get_status!(status.id)
    end

    test "delete_status/1 deletes the status" do
      status = status_fixture()
      assert {:ok, %Status{}} = Progress.delete_status(status)
      assert_raise Ecto.NoResultsError, fn -> Progress.get_status!(status.id) end
    end

    test "change_status/1 returns a status changeset" do
      status = status_fixture()
      assert %Ecto.Changeset{} = Progress.change_status(status)
    end
  end
end
