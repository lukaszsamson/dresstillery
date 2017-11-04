defmodule DresstilleryWeb.UserController do
  use DresstilleryWeb, :controller

  alias Dresstillery.Administration

  def index(conn, _params) do
    users = Administration.list_users()
    render(conn, "index.html", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Administration.get_user!(id)
    render(conn, "show.html", user: user)
  end

end
