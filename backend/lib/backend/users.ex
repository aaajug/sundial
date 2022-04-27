defmodule Backend.Users do
  import Ecto.Query, warn: false

  alias Backend.Repo
  alias Backend.Users.User
  alias Backend.Boards.Permission

  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_email(email) do
    from(user in User, where: user.email == ^email)
      |> Repo.one
  end

  def get_role(user, board_id) do
    user_id = user.id

    board_permission = user
    |> Repo.preload([permissions: from(permission in Permission, where: permission.user_id == ^user_id)])
    |> Map.fetch!(:permissions)

    if board_permission == [] do
      nil
    else
      board_permission
        |> Enum.at(0)
        |> Map.fetch(:role)
    end
  end
end
