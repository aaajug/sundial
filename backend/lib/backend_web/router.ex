defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json","html"]
  end

  scope "/api", BackendWeb do
    pipe_through :api

    get("/ping", PingController, :show)

    patch "tasks/:id/update/status", TaskController, :update_status
    get "/tasks/:id/changeset", TaskController, :changeset
    get("/tasks/default", TaskController, :list_tasks_by_default)
    get("/tasks", TaskController, :list_tasks)
    # get("/tasks/new", TaskController, :new)
    # post("/tasks/create", TaskController, :create)
    resources "/tasks", TaskController, except: [:index]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: BackendWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
