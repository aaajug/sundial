defmodule SundialWeb.UserLive.Session do
  use SundialWeb, :live_view

  alias Sundial.API.UserAPI

  @impl true
  def mount(params, _session, socket) do
    {:ok, socket}
  end
end
