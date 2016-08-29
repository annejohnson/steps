defmodule Steps.Router do
  use Steps.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Steps.Auth, repo: Steps.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Steps do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController, only: [:index, :show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/manage", Steps do
    pipe_through [:browser, :authenticate_user]

    resources "/goals", GoalController
    resources "/steps", StepController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Steps do
  #   pipe_through :api
  # end
end
