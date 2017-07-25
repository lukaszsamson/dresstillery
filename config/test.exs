use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dresstillery_backend, DresstilleryBackend.Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :dresstillery_backend, DresstilleryBackend.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "dresstillery_backend_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :comeonin,
  bcrypt_log_rounds: 1,
  pbkdf2_rounds: 500
