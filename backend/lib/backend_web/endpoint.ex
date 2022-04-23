defmodule BackendWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :backend

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_backend_key",
    signing_salt: "mifdLJ7+"
  ]

  # @pow_config [
  #   repo: Backend.Repo,
  #   user: Backend.Users.User,
  #   current_user_assigns_key: :current_user,
  #   session_key: "auth",
  #   credentials_cache_store: {Pow.Store.CredentialsCache,
  #                             ttl: :timer.minutes(30),
  #                             namespace: "credentials"},
  #   session_ttl_renewal: :timer.minutes(15),
  #   cache_store_backend: Pow.Store.Backend.EtsCache,
  #   users_context: Pow.Ecto.Users
  # ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :backend,
    gzip: false,
    only: ~w(assets fonts images favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :backend
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  # plug Pow.Plug.Session, otp_app: :backend
  plug Pow.Plug.Session, otp_app: :backend
  plug BackendWeb.Router
end
