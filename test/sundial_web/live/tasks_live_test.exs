defmodule SundialWeb.TaskLiveTest do
  use SundialWeb.ConnCase

  import Phoenix.LiveViewTest
  import Sundial.TasksFixtures

  @create_attrs %{completed_on: %{year: nil, month: nil, day: nil, hour: nil, minute: nil}, deadline: %{year: nil, month: nil, day: nil, hour: nil, minute: nil}, status: 1, description: "some description", details: "some details"}
  @update_attrs %{deadline: ~N[2022-03-17 03:09:00], status: 2, description: "some updated description", details: "some updated details"}
  @invalid_attrs %{completed_on: %{year: nil, month: nil, day: nil, hour: nil, minute: nil}, deadline: %{year: nil, month: nil, day: nil, hour: nil, minute: nil}, description: nil, details: nil}
  @invalid_task %{status: 3, details: "some updated details"}

  defp create_task(_) do
    task = task_fixture()
    in_progress_task = task_fixture(status: 2)
    on_hold_task = task_fixture(status: 3)
    completed_task = task_fixture(status: 4)

    %{task: task, in_progress_task: in_progress_task, on_hold_task: on_hold_task, completed_task: completed_task}
  end

  describe "Index" do
    setup [:create_task]

    test "lists all tasks", %{conn: conn, task: task} do
      {:ok, _index_live, html} = live(conn, Routes.task_index_path(conn, :index))

      assert html =~ "My tasks"
      assert html =~ "Not yet started"
      assert html =~ "In progress"
      assert html =~ "On hold"
      assert html =~ "Completed"
    end

    test "saves new task (with: description, status)", %{conn: conn, task: task} do
      {:ok, index_live, html} = live(conn, Routes.task_index_path(conn, :index))

      assert html =~ "Add task"
      assert html =~ "href=\"/tasks/new\""

      {:ok, index_live, html} = live(conn, Routes.task_index_path(conn, :new))
      assert html =~ "Add a new task"

      {:ok, index_live, html} =
        index_live
        |> form(".task-form-container", task: %{description: "task description", status: 1})
        |> render_submit()
        |> follow_redirect(conn, Routes.task_index_path(conn, :index))

      assert html =~ "Task created successfully"
      assert index_live
        |> element("#drag-card-#{task.id + 1}")
        |> has_element?()
    end

    test "saves new task (with: description, status, details)", %{conn: conn, task: task} do
      {:ok, index_live, html} = live(conn, Routes.task_index_path(conn, :index))

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
        |> element("#drag-card-#{task.id + 1} .flex .task-card .card-content .content", "additional details")
        |> has_element?()
    end

    test "updates status of task from initial to in progress", %{conn: conn, task: task} do
      {:ok, index_live, html} = live(conn, Routes.task_index_path(conn, :index))

      assert index_live
        |> element("#drag-card-#{task.id + 1} .flex .state-actions-container #state-action-started")
        |> has_element?()
    end

    test "updates status of task from in progress to on hold", %{conn: conn, task: in_progress_task} do
      {:ok, index_live, html} = live(conn, Routes.task_index_path(conn, :index))

    end

    test "updates status of task from on hold to completed", %{conn: conn, task: on_hold_task} do
      {:ok, index_live, html} = live(conn, Routes.task_index_path(conn, :index))
      # should have completed_on
    end

    test "updates status of task from completed to in progress", %{conn: conn, task: completed_task} do
      {:ok, index_live, html} = live(conn, Routes.task_index_path(conn, :index))
      # should no longer have completed_on
    end

    test "updates task in listing", %{conn: conn, task: task} do
      {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index))

      assert index_live |> element("#task-#{task.id} a", "Edit") |> render_click() =~
               "Edit Task"

      assert_patch(index_live, Routes.task_index_path(conn, :edit, task))

      assert index_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#task-form", task: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.task_index_path(conn, :index))

      assert html =~ "Task updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes task in listing", %{conn: conn, task: task} do
      {:ok, index_live, html} = live(conn, Routes.task_index_path(conn, :index))

      assert index_live |> element("#delete-task-#{task.id}") |> render_click()
      {:ok, index_live, html} = live(conn, Routes.task_index_path(conn, :index))
      refute has_element?(index_live, "#drag-card-#{task.id}")
    end
  end

  describe "Show" do
    setup [:create_task]

    # test "displays task", %{conn: conn, task: task} do
    #   {:ok, _show_live, html} = live(conn, Routes.task_show_path(conn, :show, task))

    #   assert html =~ "Show Task"
    #   assert html =~ task.name
    # end

    # test "updates task within modal", %{conn: conn, task: task} do
    #   {:ok, show_live, _html} = live(conn, Routes.task_show_path(conn, :show, task))

    #   assert show_live |> element("a", "Edit") |> render_click() =~
    #            "Edit Task"

    #   assert_patch(show_live, Routes.task_show_path(conn, :edit, task))

    #   assert show_live
    #          |> form("#task-form", task: @invalid_attrs)
    #          |> render_change() =~ "can&#39;t be blank"

    #   {:ok, _, html} =
    #     show_live
    #     |> form("#task-form", task: @update_attrs)
    #     |> render_submit()
    #     |> follow_redirect(conn, Routes.task_show_path(conn, :show, task))

    #   assert html =~ "Task updated successfully"
    #   assert html =~ "some updated name"
    # end
  end
end
