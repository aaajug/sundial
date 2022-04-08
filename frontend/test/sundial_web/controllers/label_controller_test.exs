defmodule SundialWeb.LabelControllerTest do
  use SundialWeb.ConnCase

  import Sundial.LabelsFixtures

  @create_attrs %{color_class: "some color_class", name: "some name"}
  @update_attrs %{color_class: "some updated color_class", name: "some updated name"}
  @invalid_attrs %{color_class: nil, name: nil}

  describe "index" do
    test "lists all labels", %{conn: conn} do
      conn = get(conn, Routes.label_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Labels"
    end
  end

  describe "new label" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.label_path(conn, :new))
      assert html_response(conn, 200) =~ "New Label"
    end
  end

  describe "create label" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.label_path(conn, :create), label: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.label_path(conn, :show, id)

      conn = get(conn, Routes.label_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Label"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.label_path(conn, :create), label: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Label"
    end
  end

  describe "edit label" do
    setup [:create_label]

    test "renders form for editing chosen label", %{conn: conn, label: label} do
      conn = get(conn, Routes.label_path(conn, :edit, label))
      assert html_response(conn, 200) =~ "Edit Label"
    end
  end

  describe "update label" do
    setup [:create_label]

    test "redirects when data is valid", %{conn: conn, label: label} do
      conn = put(conn, Routes.label_path(conn, :update, label), label: @update_attrs)
      assert redirected_to(conn) == Routes.label_path(conn, :show, label)

      conn = get(conn, Routes.label_path(conn, :show, label))
      assert html_response(conn, 200) =~ "some updated color_class"
    end

    test "renders errors when data is invalid", %{conn: conn, label: label} do
      conn = put(conn, Routes.label_path(conn, :update, label), label: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Label"
    end
  end

  describe "delete label" do
    setup [:create_label]

    test "deletes chosen label", %{conn: conn, label: label} do
      conn = delete(conn, Routes.label_path(conn, :delete, label))
      assert redirected_to(conn) == Routes.label_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.label_path(conn, :show, label))
      end
    end
  end

  defp create_label(_) do
    label = label_fixture()
    %{label: label}
  end
end
