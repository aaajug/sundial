defmodule Backend.UsersTest do
  use BackendWeb.ConnCase

  alias Backend.Users.User
  alias Pow.Plug

  @email "alice@wonderland.com"
  @password "humptydumpty"

  describe "users" do
    alias Backend.Users.User

    import Backend.UsersFixtures

    @invalid_attrs %{}

    test "creates an account and returns data %{} with access token", %{conn: conn} do
      user = %{email: @email, password: @password, password_confirmation: @password}
      conn = post(conn, "/api/registration", user)

      response = json_response(conn, 200)

      assert Map.has_key?(response, "data")
      assert Map.has_key?(response["data"], "access_token")
    end

    test "signs into a registeted account and returns data %{} with access token", %{conn: conn} do
      user = %{email: @email, password: @password, password_confirmation: @password}
      post(conn, "/api/registration", user)

      user = %{email: @email, password: @password}
      conn = post(conn, "/api/session", user)

      response = json_response(conn, 200)

      assert Map.has_key?(response, "data")
      assert Map.has_key?(response["data"], "access_token")
    end

    test "signs in with invalid email, returns error message", %{conn: conn} do
      user = %{email: @email, password: @password, password_confirmation: @password}
      post(conn, "/api/registration", user)

      user = %{email: "stranger@yahoo.com", password: @password}
      conn = post(conn, "/api/session", user)

      assert json_response(conn, 401) == %{"error" => %{"message" => "Invalid email or password.", "status" => 401}}
    end
  end
end
