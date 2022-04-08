defmodule SundialWeb.TaskLiveTest do
  use SundialWeb.ConnCase

  import Phoenix.LiveViewTest
  import Sundial.TasksFixtures

  # @create_attrs %{completed_on: %{year: nil, month: nil, day: nil, hour: nil, minute: nil}, deadline: %{year: nil, month: nil, day: nil, hour: nil, minute: nil}, status: 1, description: "some description", details: "some details"}
  # @invalid_attrs %{completed_on: %{year: nil, month: nil, day: nil, hour: nil, minute: nil}, deadline: %{year: nil, month: nil, day: nil, hour: nil, minute: nil}, description: nil, details: nil}
  # @invalid_task %{status: 3, details: "some updated details"}
  @update_attrs %{deadline: %{year: 2022, month: 1, day: 1, hour: 10, minute: 10}, status: 2, description: "some updated description", details: "some updated details"}

  defp create_task(_) do
    task = task_fixture()
    in_progress_task = task_fixture(status: 2)
    on_hold_task = task_fixture(status: 3, completed_on: nil)
    completed_task = task_fixture(status: 4)

    %{task: task, in_progress_task: in_progress_task, on_hold_task: on_hold_task, completed_task: completed_task}
  end

  describe "Index" do
    setup [:create_task]

    test "lists all tasks", %{conn: conn, task: task} do
      {:ok, index_live, html} = live(conn, Routes.task_index_path(conn, :index))

      assert html =~ "My tasks"
      assert html =~ "Not yet started"
      assert html =~ "In progress"
      assert html =~ "On hold"
      assert html =~ "Completed"

      assert index_live
        |> element("#drag-card-#{task.id}")
        |> has_element?()
    end

    test "saves new task (with: description, status)", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.task_index_path(conn, :index))

      assert html =~ "Add task"
      assert html =~ "href=\"/tasks/new\""

      {:ok, index_live, html} = live(conn, Routes.task_index_path(conn, :new))
      assert html =~ "Add a new task"

      {:ok, _index_live, html} =
        index_live
          |> form(".task-form-container", task: %{description: "task description", status: 1})
          |> render_submit()
          |> follow_redirect(conn, Routes.task_index_path(conn, :index))

      assert html =~ "Task created successfully"
    end

    test "saves new task (with: description, status, details)", %{conn: conn, task: task} do
      {:ok, _index_live, html} = live(conn, Routes.task_index_path(conn, :index))

      assert html =~ "Add task"
      assert html =~ "href=\"/tasks/new\""

      {:ok, index_live, html} = live(conn, Routes.task_index_path(conn, :new))
      assert html =~ "Add a new task"

      {:ok, index_live, html} =
        index_live
        |> form(".task-form-container", task: %{description: "some new description", status: 1, details: "additional details", details_plaintext: "additional details"})
        |> render_submit()
        |> follow_redirect(conn, Routes.task_index_path(conn, :index))

      assert html =~ "Task created successfully"

      # assert render_component(SundialWeb.Live.Task.TaskComponent, id: task.id + 1, task: task, card_index: 0, drag_hook: "", return_to: "/")
      #   =~ "additional details"
      # |> element("#drag-card-#{task.id + 1} .flex .task-card .card-content")
        # |> has_element?()

      assert index_live
        |> element("#drag-card-#{task.id + 4} .flex .task-card .card-content .content", "additional details")
        |> has_element?()
    end

    test "updates status of task from initial to in progress", %{conn: conn, task: task} do
      {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index))

      {:ok, index_live, _html} =
        assert index_live
          |> element("#drag-card-#{task.id} #state-action-started")
          |> render_click()
          |> follow_redirect(conn, Routes.task_index_path(conn, :index))

      assert index_live
        |> element("#task-list-2 #drag-card-#{task.id}")
        |> has_element?()
    end

    test "updates status of task from in progress to on hold", %{conn: conn, in_progress_task: in_progress_task} do
      {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index))

      {:ok, index_live, _html} =
        assert index_live
          |> element("#drag-card-#{in_progress_task.id} #state-action-paused")
          |> render_click()
          |> follow_redirect(conn, Routes.task_index_path(conn, :index))

      assert index_live
        |> element("#task-list-3 #drag-card-#{in_progress_task.id}")
        |> has_element?()
    end

    test "updates status of task from on hold to completed (completed_on is present)", %{conn: conn, on_hold_task: task} do
      {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index))

      {:ok, index_live, _html} =
        assert index_live
          |> element("#drag-card-#{task.id} #state-action-completed")
          |> render_click()
          |> follow_redirect(conn, Routes.task_index_path(conn, :index))

      assert index_live
        |> element("#task-list-4 #drag-card-#{task.id}", "Completed:")
        |> has_element?()

        # assert render_component(SundialWeb.Live.Task.TaskComponent, id: task.id, task: task, card_index: 0, drag_hook: "", return_to: "/")
        # =~ "Completed:"
    end

    test "updates status of task from completed to in progress (completed_on is removed)", %{conn: conn, completed_task: task} do
      {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index))

      {:ok, index_live, _html} =
        assert index_live
          |> element("#drag-card-#{task.id} #state-action-initial")
          |> render_click()
          |> follow_redirect(conn, Routes.task_index_path(conn, :index))

      assert index_live
        |> element("#task-list-1 #drag-card-#{task.id}")
        |> has_element?()

      refute index_live
        |> element("#task-list-1 #drag-card-#{task.id}", "Completed:")
        |> has_element?()
    end

    test "updates task in listing", %{conn: conn, task: task} do
      {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index))

      assert index_live |> element("#drag-card-#{task.id} #edit-task") |> render_click() =~
               "Edit Task"

      assert_patch(index_live, Routes.task_index_path(conn, :edit, task, %{return_to: "/"}))

      {:ok, _, html} =
        index_live
        |> form(".task-form-container", task: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.task_index_path(conn, :index))

      assert html =~ "Task updated successfully"
    end

    test "deletes task in listing", %{conn: conn, task: task} do
      {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index))

      assert index_live |> element("#delete-task-#{task.id}") |> render_click()
      {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index))
      refute has_element?(index_live, "#drag-card-#{task.id}")
    end

    test "redirects to default sorting link when toggle sort button is clicked", %{conn: conn, task: task} do
      {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index))

      index_live
        |> element("#toggle-sorting", "Enable default sorting")
        |> render_click()

      assert_redirect(index_live, Routes.task_index_path(conn, :index, %{sort: "default"}))
    end

    test "toggles sorting button to show active default sorting when clicked", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index))

      {:ok, index_live, _html} =
        index_live
          |> element("#toggle-sorting", "Enable default sorting")
          |> render_click()
          |> follow_redirect(conn, Routes.task_index_path(conn, :index, %{sort: "default"}))

      refute index_live
        |> element("#toggle-sorting", "Enable default sorting")
        |> has_element?()

      assert index_live
        |> element("#toggle-sorting", "Disable default sorting")
        |> has_element?()
    end
  end
end
