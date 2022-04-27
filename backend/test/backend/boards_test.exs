defmodule Backend.BoardsTest do
  use BackendWeb.ConnCase

  alias Backend.Boards
  alias Backend.Users.User
  alias Pow.Plug

  @email "alice@wonderland.com"
  @password "humptydumpty"

  describe "boards" do
    alias Backend.Boards.Board

    import Backend.BoardsFixtures

    @invalid_attrs %{}

    test "unauthorized access of /api/boards should be blocked (401)", %{conn: conn} do
      conn = get(conn, "/api/boards")
      assert json_response(conn, 401) == %{"error" => %{"code" => 401, "message" => "Not authenticated"}}
    end

    test "unauthorized access of /api/shared_boards should be blocked (401)", %{conn: conn} do
      conn = get(conn, "/api/shared_boards")
      assert json_response(conn, 401) == %{"error" => %{"code" => 401, "message" => "Not authenticated"}}
    end

    test "unauthorized user can't create a board", %{conn: conn} do
      conn = post(conn, "/api/boards", %{data: %{title: "New board"}})

      assert json_response(conn, 401) == %{"error" => %{"code" => 401, "message" => "Not authenticated"}}
    end

    test "authorized user with no boards should return []", %{conn: conn} do
      user = %User{email: @email, id: 1}
      conn = Pow.Plug.assign_current_user(conn, user, [])

      conn = get(conn, "/api/boards")
      assert json_response(conn, 200) == %{"data" => []}
    end

    test "authorized user with boards should return list of boards", %{conn: conn} do
      user = %User{email: @email, id: 1}
      conn = Pow.Plug.assign_current_user(conn, user, [])

      conn = get(conn, "/api/boards")
      response = json_response(conn, 200)

      assert Map.has_key?(response, "data") == true
    end

    test "authorized user with shared boards should return list of shared boards", %{conn: conn} do
      user = %User{email: @email, id: 1}
      conn = Pow.Plug.assign_current_user(conn, user, [])

      conn = get(conn, "/api/shared_boards")
      response = json_response(conn, 200)

      assert Map.has_key?(response, "data") == true
    end

    test "gets list of user roles in a board", %{conn: conn} do
      conn = get(conn, "/api/boards/roles")
      assert json_response(conn, 200) == %{"data" => ["manager", "contributor", "member"]}
    end
  end
end
