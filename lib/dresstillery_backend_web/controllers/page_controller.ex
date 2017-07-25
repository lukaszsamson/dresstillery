defmodule DresstilleryBackendWeb.PageController do
  use DresstilleryBackendWeb, :controller

  def index(conn, _params) do
    render conn, "admin_index.html"
  end

end
