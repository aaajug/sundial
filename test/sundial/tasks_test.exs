defmodule Sundial.TasksTest do
  use Sundial.DataCase

  alias Sundial.Tasks

  describe "tasks" do
    alias Sundial.Tasks.Task

    import Sundial.TasksFixtures

    @invalid_attrs %{completed_at: nil, deadline: nil, description: nil, details: nil, pane_id: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Tasks.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Tasks.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{completed_at: ~N[2022-03-16 03:09:00], deadline: ~N[2022-03-16 03:09:00], description: "some description", details: "some details", pane_id: 42}

      assert {:ok, %Task{} = task} = Tasks.create_task(valid_attrs)
      assert task.completed_at == ~N[2022-03-16 03:09:00]
      assert task.deadline == ~N[2022-03-16 03:09:00]
      assert task.description == "some description"
      assert task.details == "some details"
      assert task.pane_id == 42
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{completed_at: ~N[2022-03-17 03:09:00], deadline: ~N[2022-03-17 03:09:00], description: "some updated description", details: "some updated details", pane_id: 43}

      assert {:ok, %Task{} = task} = Tasks.update_task(task, update_attrs)
      assert task.completed_at == ~N[2022-03-17 03:09:00]
      assert task.deadline == ~N[2022-03-17 03:09:00]
      assert task.description == "some updated description"
      assert task.details == "some updated details"
      assert task.pane_id == 43
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task == Tasks.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end
  end
end
