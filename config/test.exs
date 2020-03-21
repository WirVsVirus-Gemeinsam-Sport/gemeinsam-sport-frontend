use Mix.Config

# Configure your database
config :gemeinsam_sport_frontend, GemeinsamSportFrontend.Repo,
  username: "postgres",
  password: "postgres",
  database: "gemeinsam_sport_frontend_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :gemeinsam_sport_frontend, GemeinsamSportFrontendWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
