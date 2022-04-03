defmodule SundialWeb.LabelLiveTest do
  use SundialWeb.ConnCase

  import Phoenix.LiveViewTest
  import Sundial.LabelsFixtures

  @create_attrs %{color: "some color", name: "some name"}
  @update_attrs %{color: "some updated color", name: "some updated name"}
  @invalid_attrs %{color: nil, name: nil}

  defp create_label(_) do
    label = label_fixture()
    %{label: label}
  end

  describe "Index" do
    setup [:create_label]

    test "lists all labels", %{conn: conn, label: label} do
      {:ok, _index_live, html} = live(conn, Routes.label_index_path(conn, :index))

      assert html =~ "Listing Labels"
      assert html =~ label.color
    end

    test "saves new label", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.label_index_path(conn, :index))

      assert index_live |> element("a", "New Label") |> render_click() =~
               "New Label"

      assert_patch(index_live, Routes.label_index_path(conn, :new))

      assert index_live
             |> form("#label-form", label: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#label-form", label: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.label_index_path(conn, :index))

      assert html =~ "Label created successfully"
      assert html =~ "some color"
    end

    test "updates label in listing", %{conn: conn, label: label} do
      {:ok, index_live, _html} = live(conn, Routes.label_index_path(conn, :index))

      assert index_live |> element("#label-#{label.id} a", "Edit") |> render_click() =~
               "Edit Label"

      assert_patch(index_live, Routes.label_index_path(conn, :edit, label))

      assert index_live
             |> form("#label-form", label: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#label-form", label: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.label_index_path(conn, :index))

      assert html =~ "Label updated successfully"
      assert html =~ "some updated color"
    end

    test "deletes label in listing", %{conn: conn, label: label} do
      {:ok, index_live, _html} = live(conn, Routes.label_index_path(conn, :index))

      assert index_live |> element("#label-#{label.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#label-#{label.id}")
    end
  end

  describe "Show" do
    setup [:create_label]

    test "displays label", %{conn: conn, label: label} do
      {:ok, _show_live, html} = live(conn, Routes.label_show_path(conn, :show, label))

      assert html =~ "Show Label"
      assert html =~ label.color
    end

    test "updates label within modal", %{conn: conn, label: label} do
      {:ok, show_live, _html} = live(conn, Routes.label_show_path(conn, :show, label))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Label"

      assert_patch(show_live, Routes.label_show_path(conn, :edit, label))

      assert show_live
             |> form("#label-form", label: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#label-form", label: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.label_show_path(conn, :show, label))

      assert html =~ "Label updated successfully"
      assert html =~ "some updated color"
    end
  end
end
