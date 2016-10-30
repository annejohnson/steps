defmodule Steps.Router do
  use Steps.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :browser_user_authenticated do
    plug Guardian.Plug.EnsureAuthenticated, handler: Steps.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]

    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  scope "/", Steps do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/", Steps do
    pipe_through [:browser, :browser_user_authenticated]

    resources "/goals", GoalController do
      resources "/steps", StepController, except: [:index, :show]
    end
  end

  scope "/api", Steps.API do
    pipe_through :api

    scope "/v1", V1 do
      resources "/sessions", SessionController, only: [:create]
      resources "/users", UserController, only: [:create]
      resources "/goals", GoalController, except: [:new, :edit]
      resources "/steps", StepController, except: [:new, :edit]
    end
  end
end
