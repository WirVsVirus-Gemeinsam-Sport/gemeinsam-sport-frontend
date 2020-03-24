defmodule GemeinsamSportFrontendWeb.Router do
  use GemeinsamSportFrontendWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :health_check, "/healthz"
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

    get "/", LandingPageController, :index
    resources "/", RoomController
  end

  defp health_check(%{request_path: path, halted: false} = conn, path) do
    conn
    |> Plug.Conn.put_resp_header("content-type", "text/html")
    |> Plug.Conn.send_resp(200, "OK")
    |> Plug.Conn.halt()
  end

  defp health_check(conn, _), do: conn
end
