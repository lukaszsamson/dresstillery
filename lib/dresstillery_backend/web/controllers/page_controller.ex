defmodule DresstilleryBackend.Web.PageController do
  use DresstilleryBackend.Web, :controller

  def index(conn, _params) do
    render conn, "admin_index.html"
  end

end
