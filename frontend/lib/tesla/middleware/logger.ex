defmodule Tesla.Middleware.Logger do
  @behaviour Tesla.Middleware

  @impl Tesla.Middleware
  def call(env, next, _) do
    env
    |> IO.inspect(label: "Env")
    |> Tesla.run(next)
    |> IO.inspect(label: "Response")
  end
end
