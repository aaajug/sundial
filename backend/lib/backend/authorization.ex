defmodule Backend.Authorization do
  alias __MODULE__
  alias Backend.Users.User
  alias Backend.Boards.Board
  alias Backend.Lists.List
  alias Backend.Tasks.Task
  alias Backend.Tasks.Comment

  defstruct role: nil, create: %{}, read: %{}, update: %{}, delete: %{},
                       list_tasks: %{}, update_positions: %{}, update_status: %{}

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
    # |> list_tasks(Task)
    |> read(Comment)
    |> create(Comment)
    |> create(List)
    |> update(List)
    # |> update_positions(List)
    |> create(Task)
    |> update(Task)
    # |> update_positions(Task)
    # |> update_status(Task)
  end

  def can("member" = role) do
    grant(role)
    |> read(Board)
    |> read(List)
    # |> list_tasks(Task)
    |> read(Comment)
    |> create(Comment)
  end

  def can(_ = role) do
    grant(role)
  end

  def grant(role), do: %Authorization{role: role}

  def read(authorization, resource), do: put_action(authorization, :read, resource)

  def create(authorization, resource), do: put_action(authorization, :create, resource)

  def update(authorization, resource), do: put_action(authorization, :update, resource)

  def delete(authorization, resource), do: put_action(authorization, :delete, resource)

  # def list_tasks(authorization, resource), do: put_action(authorization, :list_tasks, resource)

  # def update_positions(authorization, resource), do: put_action(authorization, :update_positions, resource)

  # def update_status(authorization, resource), do: put_action(authorization, :update_status, resource)

  def all(authorization, resource) do
    authorization
    |> create(resource)
    |> read(resource)
    |> update(resource)
    |> delete(resource)
    # |> list_tasks(resource)
    # |> update_positions(resource)
    # |> update_status(resource)
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

  # def list_tasks?(authorization, resource) do
  #   Map.get(authorization.list_tasks, resource, false)
  # end

  # def update_positions?(authorization, resource) do
  #   Map.get(authorization.update_positions, resource, false)
  # end

  # def update_status?(authorization, resource) do
  #   Map.get(authorization.update_status, resource, false)
  # end

  defp put_action(authorization, action, resource) do
    updated_action =
      authorization
      |> Map.get(action)
      |> Map.put(resource, true)

    Map.put(authorization, action, updated_action)
  end
end
