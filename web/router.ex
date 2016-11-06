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
    plug Guardian.Plug.EnsureAuthenticated, handler: Steps.Auth.Browser
  end

  pipeline :api do
    plug :accepts, ["json"]

    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  pipeline :api_user_authenticated do
    plug Guardian.Plug.EnsureAuthenticated, handler: Steps.Auth.API
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

  scope "/api", Steps.API, as: :api do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      resources "/sessions", SessionController, only: [:create]
      resources "/users", UserController, only: [:create]
    end

    scope "/v1", V1, as: :v1 do
      pipe_through :api_user_authenticated

      resources "/goals", GoalController, except: [:new, :edit]
      resources "/steps", StepController, except: [:new, :edit]
    end
  end
end
