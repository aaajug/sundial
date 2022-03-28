defmodule SundialWeb.LayoutView do
  use SundialWeb, :view
  # use Phoenix.LiveView, layout: {SundialWeb, "live.html"}

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}


  # def render(assigns) do
  #   ~H"""
  #   <%= assigns %>
  #   """
  # end

  # def render(con, assigns) do
  #   ~H"""
  #   <%= assigns %>
  #   """
  # end
end
