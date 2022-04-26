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

  scope "/api", BackendWeb do
    pipe_through :api

    resources "/registration", API.RegistrationController, singleton: true, only: [:create]
    resources "/session", API.SessionController, singleton: true, only: [:create, :delete]
    get "/session", API.SessionController, :get
    get "/session/authenticated", API.SessionController, :is_authenticated
    post "/session/renew", API.SessionController, :renew

    get "/user_role", TaskController, :get_role
    get "/boards/roles", BoardController, :get_roles

    get("/ping", PingController, :show)
  end

  scope "/api", BackendWeb do
    pipe_through [:api, :api_protected]

    post "/lists/:list_id/tasks/reorder", TaskController, :update_positions
    patch "/tasks/:id/update/status", TaskController, :update_status
    get "/tasks/:id/changeset", TaskController, :changeset
    get("/tasks/default", TaskController, :list_tasks_by_default)
    get("/tasks", TaskController, :list_tasks)
    post "/boards/:board_id/lists/:list_id/tasks", TaskController, :create
    resources "/tasks", TaskController, except: [:index, :create]

    # Boards API
    # get "/boards/:id/tasks", BoardController, :get_tasks
    get "/shared_boards", BoardController, :shared_boards
    resources "/boards", BoardController

    # List API
    post "/boards/:id/lists", ListController, :create
    post "/reorder_lists", ListController, :update_positions
    resources "/lists", ListController, except: [:index]
    get "/boards/:id/lists", ListController, :index

    # Comment API
    post "/tasks/:id/comments", CommentController, :create
    delete "/comments/:id", CommentController, :delete
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
