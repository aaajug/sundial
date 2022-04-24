defmodule Backend.Authorization do
  alias __MODULE__
  alias Backend.Users.User
  alias Backend.Boards.Board
  alias Backend.Lists.List
  alias Backend.Tasks.Task
  alias Backend.Tasks.Comment

  defstruct role: nil, create: %{}, read: %{}, update: %{}, delete: %{}

  def can("manager" = role) do
    grant(role)
    |> all(Board)
    |> all(List)
    |> all(Task)
    |> all(Comment)
  end

  def can("contributor" = role) do
    grant(role)
    |> read(Board)
    |> read(List)
    |> read(Task)
    |> read(Comment)
    |> create(Comment)
    |> create(List)
    |> create(Task)
    |> update(Task)
    |> update(List)
  end

  def can("reader" = role) do
    grant(role)
    |> read(Board)
    |> read(List)
    |> read(Task)
    |> read(Comment)
    |> create(Comment)
  end

  def grant(role), do: %Authorization{role: role}

  def read(authorization, resource), do: put_action(authorization, :read, resource)

  def create(authorization, resource), do: put_action(authorization, :create, resource)

  def update(authorization, resource), do: put_action(authorization, :update, resource)

  def delete(authorization, resource), do: put_action(authorization, :delete, resource)

  def all(authorization, resource) do
    authorization
    |> create(resource)
    |> read(resource)
    |> update(resource)
    |> delete(resource)
  end

  def read?(authorization, resource) do
    Map.get(authorization.read, resource, false)
  end

  def create?(authorization, resource) do
    Map.get(authorization.create, resource, false)
  end

  def update?(authorization, resource) do
    Map.get(authorization.update, resource, false)
  end

  def delete?(authorization, resource) do
    Map.get(authorization.delete, resource, false)
  end

  defp put_action(authorization, action, resource) do
    updated_action =
      authorization
      |> Map.get(action)
      |> Map.put(resource, true)

    Map.put(authorization, action, updated_action)
  end
end
