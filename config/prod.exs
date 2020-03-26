use Mix.Config

config :gemeinsam_sport_frontend, GemeinsamSportFrontendWeb.Endpoint,
  url: [host: "corona-gym.org", port: 443],
  url: [host: "staging.corona-gym.org", port: 443],
  cache_static_manifest: "priv/static/cache_manifest.json"

# Do not print debug messages in production
config :logger, level: :info

config :gemeinsam_sport_frontend, GemeinsamSportFrontendWeb.Endpoint,
  force_ssl: [rewrite_on: [:x_forwarded_proto]]

# Finally import the config/prod.secret.exs which loads secrets
# and configuration from environment variables.
import_config "prod.secret.exs"
