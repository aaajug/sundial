defmodule SundialWeb.Router do
  use SundialWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SundialWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug SundialWeb.APIAuthPlug, otp_app: :sundial
  end

  pipeline :api_protected do
    plug Pow.Plug.RequireAuthenticated, error_handler: SundialWeb.APIAuthErrorHandler
  end

  scope "/api", SundialWeb.API, as: :api do
    pipe_through :api

    resources "/registration", RegistrationController, singleton: true, only: [:create]
    resources "/session", SessionController, singleton: true, only: [:create, :delete]
    post "/session/renew", SessionController, :renew
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  scope "/", SundialWeb do
    pipe_through :browser

    get("/ping", PingController, :show)

    # get "/", TaskController, :index
    # live "/", TaskViewLive
    # live "/", TaskLive.Index, :index
    live "/", BoardLive.Index, :index
    live "/tasks/new", TaskLive.Index, :new
    live "/tasks/:id/edit", TaskLive.Index, :edit


    # resources "/users", UsersController, only: [:create, :update, :delete]
    # scope path: "/account" do
    #   get "/login", UsersController, :index
    #   get "/register", UsersController, :new
    #   get "/edit", UsersController, :edit
    #   get "/logout", UsersController, :logout
    # end

    # resources "/tasks", TaskController, only: [:show, :create, :update, :delete]
    # live "/tasks", TaskController

    # live "/tasks/:id/update", TaskController, as: :update

    # resources "/tasks", TaskController

    resources "/labels", LabelController

    resources "/status", StatusController

    # resources "/panes", PanesController

    # resources "/boards", BoardsController

    # get "/attachments", AttachmentsController, :index

    live "/boards", BoardLive.Index, :index
    live "/boards/new", BoardLive.Index, :new
    live "/boards/:id/edit", BoardLive.Index, :edit

    # live "/boards/:id", BoardLive.Show, :show
    live "/boards/:id", TaskLive.Index, :index
    live "/boards/:id/show/edit", BoardLive.Show, :edit

    live "/lists", ListLive.Index, :index
    live "/boards/:id/lists/new", ListLive.Index, :new
    live "/lists/:id/edit", ListLive.Index, :edit

    live "/lists/:id", ListLive.Show, :show
    live "/lists/:id/show/edit", ListLive.Show, :edit

    live "/comments", CommentLive.Index, :index
    live "/comments/new", CommentLive.Index, :new
    live "/comments/:id/edit", CommentLive.Index, :edit

    live "/comments/:id", CommentLive.Show, :show
    live "/comments/:id/show/edit", CommentLive.Show, :edit

    live "/permissions", PermissionLive.Index, :index
    live "/permissions/new", PermissionLive.Index, :new
    live "/permissions/:id/edit", PermissionLive.Index, :edit

    live "/permissions/:id", PermissionLive.Show, :show
    live "/permissions/:id/show/edit", PermissionLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", SundialWeb do
  #   pipe_through :api
  # end

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
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SundialWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
