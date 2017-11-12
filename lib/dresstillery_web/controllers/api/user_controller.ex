defmodule DresstilleryWeb.Api.UserController do
  use DresstilleryWeb, :controller

  alias Dresstillery.Administration
  alias Dresstillery.Administration.User

  action_fallback(DresstilleryWeb.FallbackController)

  def register(conn, user_params) do
    with {:ok, %User{} = user} <- Administration.register(user_params) do
      conn
      |> render("show.json", user: user)
    end
  end

  def login(conn, user_params) do
    with {:ok, %User{} = user} <- Administration.login(user_params) do
      conn
      |> render("show.json", user: user)
    end
  end

  def login_facebook(conn, %{"token" => token}) do
    with {:ok, %User{} = user} <- Administration.login_facebook(token) do
      conn
      |> render("show.json", user: user)
    end
  end

  # def logout(conn, %{"user" => user_params}) do
  #   with {:ok, %User{} = user} <- Administration.create_user(user_params) do
  #     conn
  #     |> put_status(:created)
  #     |> put_resp_header("location", api_user_path(conn, :show, user))
  #     |> render("show.json", user: user)
  #   end
  # end
end
