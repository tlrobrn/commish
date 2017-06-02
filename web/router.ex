defmodule Commish.Router do
  use Commish.Web, :router

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

  scope "/", Commish do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/league_nodes", LeagueNodeController
    resources "/teams", TeamController
    resources "/schedule_settings", ScheduleSettingController
    resources "/tournament_configurations", TournamentConfigurationController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Commish do
  #   pipe_through :api
  # end
end
