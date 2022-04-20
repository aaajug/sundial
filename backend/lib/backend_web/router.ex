defmodule BackendWeb.Router do
  use BackendWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json","html"]
    plug BackendWeb.APIAuthPlug, otp_app: :backend
  end

  pipeline :api_protected do
    plug Pow.Plug.RequireAuthenticated, error_handler: BackendWeb.APIAuthErrorHandler
  end

  # scope "/" do
  #   pipe_through :browser

  #   pow_routes()
  # end

  # scope "/api", BackendWeb.API, as: :api do
  #   pipe_through :api

  #   # resources "/registration", RegistrationController, singleton: true, only: [:create]
  #   # resources "/session", SessionController, singleton: true, only: [:create, :delete]
  #   # post "/session/renew", SessionController, :renew
  # end

  scope "/api", BackendWeb do
    pipe_through :api

    resources "/registration", API.RegistrationController, singleton: true, only: [:create]
    resources "/session", API.SessionController, singleton: true, only: [:create, :delete]
    post "/session/renew", API.SessionController, :renew

    get("/ping", PingController, :show)

    post "/tasks/reorder", TaskController, :update_positions
    patch "/tasks/:id/update/status", TaskController, :update_status
    get "/tasks/:id/changeset", TaskController, :changeset
    get("/tasks/default", TaskController, :list_tasks_by_default)
    get("/tasks", TaskController, :list_tasks)
    # get("/tasks/new", TaskController, :new)
    # post("/tasks/create", TaskController, :create)
    resources "/tasks", TaskController, except: [:index]

    # Boards API
    get "/boards/:id/tasks", BoardController, :get_tasks
    resources "/boards", BoardController
    resources "/lists", ListController
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
