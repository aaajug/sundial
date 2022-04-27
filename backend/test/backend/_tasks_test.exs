defmodule _Backend.TasksTest do
  use BackendWeb.ConnCase

  alias Backend.Boards
  alias Backend.Users.User
  alias Pow.Plug
  alias Backend.Tasks

  describe "tasks" do
    alias Backend.Tasks.Task

    import Backend.TasksFixtures

    @invalid_attrs %{completed_on: nil, deadline: nil, description: nil, details: nil, pane_id: nil, position: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Tasks.list_tasks() == [task]
    end

    test "list_tasks/1 returns tasks with ids as enumerated in the given list" do
      task = task_fixture()
      assert Tasks.list_tasks([task.id]) == [task]
    end

    test "list_tasks_by_position/0 returns all tasks in order of their position" do
      task = task_fixture()
      assert Tasks.list_tasks_by_position() == [task]
    end

    test "update_position/2 updates position of a task based on the given parameters" do
      task = task_fixture()
      position = 100

      assert {:ok, %Task{} = task} = Tasks.update_position(task, position)
      assert task.position == position
    end

    test "get_position/1 returns the position of the task with the given id" do
      task = task_fixture()
      assert Tasks.get_position(task.id) == [task.position]
    end

    test "update_positions/1 updates positions in order of the task ids given by the list" do
      list = [task_fixture(position: 100), task_fixture(position: 300), task_fixture(position: 200), task_fixture(position: 500)]
      list_ids = list |> Enum.map(fn t -> t.id end)
      new_positions = [0, 1000, 2000, 3000, 4000]

      {:ok, list, _} = Tasks.update_positions(list_ids)

      list |>
        Enum.with_index(
          fn {:ok, task}, i ->
            assert task.position == Enum.at(new_positions, i)
          end
        )
    end

    test "rollback/1 updates given tasks based on the the passed rollback data (specially to rollback task positions)" do
      list = [task_fixture(position: 100), task_fixture(position: 300), task_fixture(position: 200), task_fixture(position: 500)]
      list_ids = list |> Enum.map(fn t -> t.id end)

      initial_positions = list
                            |> Enum.map(
                                fn t ->
                                  %{id: t.id, attr: %{"position" => t.position}}
                                end
                              )

      Tasks.update_positions(list_ids)
      Tasks.rollback(initial_positions)

      list |>
        Enum.with_index(
          fn task, i ->
            obj = Enum.at(initial_positions, i)
            assert task.position == obj.attr["position"]
          end
        )
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Tasks.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{completed_on: ~N[2022-03-16 03:09:00], deadline: ~N[2022-03-16 03:09:00], description: "some description", details: "some details", pane_id: 42, position: 100}

      assert {:ok, %Task{} = task} = Tasks.create_task(valid_attrs)
      assert task.completed_on == ~N[2022-03-16 03:09:00]
      assert task.deadline == ~N[2022-03-16 03:09:00]
      assert task.description == "some description"
      assert task.details == "some details"
      assert task.pane_id == 42
      assert task.position == 100
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task (with completed_on, non-completed status)" do
      task = task_fixture()
      update_attrs = %{completed_on: ~N[2022-03-17 03:09:00], deadline: ~N[2022-03-17 03:09:00], status: 2, description: "some updated description", details: "some updated details", pane_id: 43, position: 200}

      assert {:ok, %Task{} = task} = Tasks.update_task(task, update_attrs)
      assert task.completed_on == nil
      assert task.deadline == ~N[2022-03-17 03:09:00]
      assert task.description == "some updated description"
      assert task.details == "some updated details"
      assert task.pane_id == 43
      assert task.position == 200
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

  describe "comments" do
    alias Backend.Tasks.Comment

    import Backend.TasksFixtures

    @invalid_attrs %{content: nil, task_id: nil, user_id: nil}

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Tasks.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Tasks.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      valid_attrs = %{content: "some content", task_id: 42, user_id: 42}

      assert {:ok, %Comment{} = comment} = Tasks.create_comment(valid_attrs)
      assert comment.content == "some content"
      assert comment.task_id == 42
      assert comment.user_id == 42
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      update_attrs = %{content: "some updated content", task_id: 43, user_id: 43}

      assert {:ok, %Comment{} = comment} = Tasks.update_comment(comment, update_attrs)
      assert comment.content == "some updated content"
      assert comment.task_id == 43
      assert comment.user_id == 43
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_comment(comment, @invalid_attrs)
      assert comment == Tasks.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Tasks.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Tasks.change_comment(comment)
    end
  end
end
