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
    plug DresstilleryWeb.Authenticate
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug DresstilleryWeb.Authenticate, require_session: false
    plug DresstilleryWeb.Locale, "pl"
  end

  scope "/admin", DresstilleryWeb do
    pipe_through :browser # Use the default browser stack

    get   "/login",   SessionController, :login_page
    post  "/login",   SessionController, :login
    get   "/tfa",     SessionController, :tfa_page
    post  "/tfa",     SessionController, :tfa
    post  "/logout",  SessionController, :logout
  end

  scope "/admin", DresstilleryWeb do
    pipe_through [:browser, :browser_secure]

    get "/", PageController, :index

    post "/backoffice_users/:id/reset_password", BackofficeUserController, :reset_password
    resources "/backoffice_users", BackofficeUserController

    resources "/product_types", ProductTypeController

    resources "/products", ProductController
    post "/products/:product_id/images/:id/move_down", ProductImageController, :increase_order
    post "/products/:product_id/images/:id/move_up", ProductImageController, :decrease_order
    resources "/products/:product_id/images", ProductImageController
    resources "/images", ImageController, except: [:edit, :update]

    resources "/fabrics", FabricController
    resources "/fabrics/:fabric_id/images", FabricImageController

    resources "/users", UserController, only: [:show, :index]
    resources "/orders", OrderController

    get   "/change_password",   SessionController, :change_password_page
    post  "/change_password",   SessionController, :change_password
  end

  # Other scopes may use custom stacks.
  scope "/api", DresstilleryWeb.Api, as: :api do
    pipe_through :api

    resources "/products", ProductController, only: [:show, :index]
    resources "/fabrics", FabricController, only: [:show, :index]

    post "/account/login", UserController, :login
    post "/account/register", UserController, :register
    post "/account/login_facebook", UserController, :login_facebook
  end
end
