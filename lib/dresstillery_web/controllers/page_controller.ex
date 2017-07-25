defmodule DresstilleryWeb.PageController do
  use DresstilleryWeb, :controller

  def index(conn, _params) do
    render conn, "admin_index.html"
  end
end
