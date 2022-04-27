defmodule Backend.AuthorizationTest do
  use ExUnit.Case
  import Backend.Authorization

  alias Backend.Boards.Board
  alias Backend.Lists.List
  alias Backend.Tasks.Task
  alias Backend.Tasks.Comment

  test "member can read board" do
    assert can("member") |> read?(Board)
  end

  test "member can read list" do
    assert can("member") |> read?(List)
  end

  test "member can read task" do
    assert can("member") |> read?(Task)
  end

  test "member can read comment" do
    assert can("member") |> read?(Comment)
  end

  test "member can create comment" do
    assert can("member") |> create?(Comment)
  end

  test "contributor can read board" do
    assert can("contributor") |> read?(Board)
  end

  test "contributor can read list" do
    assert can("contributor") |> read?(List)
  end

  test "contributor can read task" do
    assert can("contributor") |> read?(Task)
  end

  test "contributor can read comment" do
    assert can("contributor") |> read?(Comment)
  end

  test "contributor can create comment" do
    assert can("contributor") |> create?(Comment)
  end

  test "contributor can create list" do
    assert can("contributor") |> create?(List)
  end

  test "contributor can create task" do
    assert can("contributor") |> create?(Task)
  end

  test "contributor can update list" do
    assert can("contributor") |> update?(List)
  end

  test "contributor can update task" do
    assert can("contributor") |> update?(Task)
  end

  test "manager can read board" do
    assert can("manager") |> read?(Board)
  end

  test "manager can update board" do
    assert can("manager") |> update?(Board)
  end

  test "manager can delete board" do
    assert can("manager") |> delete?(Board)
  end

  test "manager can read list" do
    assert can("manager") |> read?(List)
  end

  test "manager can create list" do
    assert can("manager") |> create?(List)
  end

  test "manager can update list" do
    assert can("manager") |> update?(List)
  end

  test "manager can delete list" do
    assert can("manager") |> delete?(List)
  end

  test "manager can read task" do
    assert can("manager") |> read?(Task)
  end

  test "manager can create task" do
    assert can("manager") |> create?(Task)
  end

  test "manager can update task" do
    assert can("manager") |> update?(Task)
  end

  test "manager can delete task" do
    assert can("manager") |> delete?(Task)
  end

  test "manager can read comment" do
    assert can("manager") |> read?(Comment)
  end

  test "manager can create comment" do
    assert can("manager") |> create?(Comment)
  end
end
