defmodule DresstilleryWeb.Router do
  use DresstilleryWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_secure do
    # plug DresstilleryWeb.Authenticate
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/admin", DresstilleryWeb do
    pipe_through :browser # Use the default browser stack

  end

  scope "/admin", DresstilleryWeb do
    pipe_through [:browser, :browser_secure]

    get "/", PageController, :index

    post "/backoffice_users/:id/reset_password", BackofficeUserController, :reset_password
    resources "/backoffice_users", BackofficeUserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", DresstilleryWeb do
  #   pipe_through :api
  # end
end
