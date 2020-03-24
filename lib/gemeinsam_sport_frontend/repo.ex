defmodule GemeinsamSportFrontend.Repo do
  use Ecto.Repo,
    otp_app: :gemeinsam_sport_frontend,
    adapter: Ecto.Adapters.Postgres

  def init(_context, config) do
    config = Keyword.merge([url: System.get_env("DATABASE_URL")], config)
    if not Keyword.has_key?(config, :url) do
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """
    end

    {:ok, config}
  end
end
