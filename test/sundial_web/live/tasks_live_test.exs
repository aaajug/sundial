defmodule SundialWeb.TaskLiveTest do
  use SundialWeb.ConnCase

  import Phoenix.LiveViewTest
  import Sundial.TasksFixtures

  @create_attrs %{completed_on: ~N[2022-03-16 03:09:00], deadline: ~N[2022-03-16 03:09:00], status: 4, description: "some description", details: "some details", pane_id: 42, position: 100}
  @update_attrs %{deadline: ~N[2022-03-17 03:09:00], status: 2, description: "some updated description", details: "some updated details", pane_id: 43, position: 200}
  @invalid_attrs %{completed_on: nil, deadline: nil, description: nil, details: nil, pane_id: nil, position: nil}

  defp create_task(_) do
    task = task_fixture()
    %{task: task}
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

    test "saves new task", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index))

      assert index_live |> element("new-task-link") |> render_click() =~
               "Add a new task"

      # assert_patch(index_live, Routes.task_index_path(conn, :new))

      # assert index_live
      #        |> form("#task-form", task: @invalid_attrs)
      #        |> render_change() =~ "can&#39;t be blank"

      # {:ok, _, html} =
      #   index_live
      #   |> form("#task-form", task: @create_attrs)
      #   |> render_submit()
      #   |> follow_redirect(conn, Routes.task_index_path(conn, :index))

      # assert html =~ "Task created successfully"
      # assert html =~ "some name"
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
      {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index))

      assert index_live |> element("#task-#{task.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#task-#{task.id}")
    end
  end

  describe "Show" do
    setup [:create_task]

    test "displays task", %{conn: conn, task: task} do
      {:ok, _show_live, html} = live(conn, Routes.task_show_path(conn, :show, task))

      assert html =~ "Show Task"
      assert html =~ task.name
    end

    test "updates task within modal", %{conn: conn, task: task} do
      {:ok, show_live, _html} = live(conn, Routes.task_show_path(conn, :show, task))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Task"

      assert_patch(show_live, Routes.task_show_path(conn, :edit, task))

      assert show_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#task-form", task: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.task_show_path(conn, :show, task))

      assert html =~ "Task updated successfully"
      assert html =~ "some updated name"
    end
  end
end
