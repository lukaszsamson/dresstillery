use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dresstillery, DresstilleryWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :dresstillery, Dresstillery.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "dresstillery_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :comeonin,
  bcrypt_log_rounds: 1,
  pbkdf2_rounds: 500

config :dresstillery, :upload_directory, "/priv/fixture/uploads"

config :dresstillery, :oauth,
  facebook_app_id: "12345",
  facebook_app_secret: "67890",
  facebook_verify_token_url: "https://graph.facebook.com/debug_token"

config :dresstillery, :facebook_api, Dresstillery.FacebookApiStub
