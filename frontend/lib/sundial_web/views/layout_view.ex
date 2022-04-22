defmodule SundialWeb.LayoutView do
  use SundialWeb, :view
  alias SundialWeb.SessionHandler
  # use Phoenix.LiveView, layout: {SundialWeb, "live.html"}

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}


  # def render(assigns) do
  #   ~H"""
  #   <%= assigns %>
  #   """
  # end

  # def render(conn, assigns) do
  # end

  def has_current_user(conn) do
    SessionHandler.fetch_current_user_access_token(conn)
  end
end
