defmodule GemeinsamSportFrontendWeb.Router do
  use GemeinsamSportFrontendWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GemeinsamSportFrontendWeb do
    pipe_through :browser

    resources "/", RoomController
  end

  # Other scopes may use custom stacks.
  # scope "/api", GemeinsamSportFrontendWeb do
  #   pipe_through :api
  # end
end
