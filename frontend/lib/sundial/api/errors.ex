defmodule Sundial.API.Errors do
  @error %{
    email: "Email already in use. Please login or use another email to signup. "
  }

  def fetch(key) do
    @error[key]
  end
end
