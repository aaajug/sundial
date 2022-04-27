defmodule Backend.ListsTest do
  use BackendWeb.ConnCase

  alias Backend.Boards
  alias Backend.Users.User
  alias Pow.Plug

  @email "alice@wonderland.com"
  @password "humptydumpty"

  describe "lists" do
    alias Backend.Lists.List
    import Backend.ListsFixtures

    @invalid_attrs %{}

    test "non-logged in user can't access board's lists", %{conn: conn} do
      conn = post(conn, "/api/boards/1/lists")
      assert json_response(conn, 401) == %{"error" => %{"code" => 401, "message" => "Not authenticated"}}
    end

    test "non-logged in user can't reorder lists", %{conn: conn} do
      conn = post(conn, "/api/reorder_lists")
      assert json_response(conn, 401) == %{"error" => %{"code" => 401, "message" => "Not authenticated"}}
    end
end
