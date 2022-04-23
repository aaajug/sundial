defmodule Backend.Users do
  import Ecto.Query, warn: false

  alias Backend.Repo
  alias Backend.Users.User

  def get_user_by_email(email) do
    from(user in User, where: user.email == ^email)
      |> Repo.one
  end
end
