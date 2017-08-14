defmodule DresstilleryWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :dresstillery

  @static_opts [at: "/", from: :dresstillery, gzip: false]

  socket "/socket", DresstilleryWeb.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    (@static_opts ++
    [only: ~w(css fonts img js favicon.ico robots.txt manifest.json browserconfig.xml favicons)])

  plug Plug.Static,
    at: "/media", from: {:dresstillery, Application.fetch_env!(:dresstillery, :upload_directory)}, gzip: false

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug PhoenixHisto,
    static_opts: @static_opts,
    blacklist: ["/api", "/admin"]

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_dresstillery_key",
    signing_salt: "8mjattpP",
    max_age: 60 * 60 # 1h

  plug DresstilleryWeb.Router

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    if config[:load_from_system_env] do
      port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"
      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      {:ok, config}
    end
  end
end
