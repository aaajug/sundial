defmodule Tesla.Middleware.Logger do
  @behaviour Tesla.Middleware

  @impl Tesla.Middleware
  def call(env, next, _) do
    env
    |> IO.inspect("Env: ")
    |> Tesla.run(next)
    |> IO.inspect("Response: ")
  end
end
