defmodule DresstilleryWeb.Api.FabricController do
  use DresstilleryWeb, :controller

  alias Dresstillery.Dictionaries

  action_fallback DresstilleryWeb.FallbackController

  def index(conn, _params) do
    fabrics = Dictionaries.list_visible_fabrics()
    render(conn, "index.json", fabrics: fabrics)
  end

  def show(conn, %{"id" => id}) do
    fabric = Dictionaries.get_visible_fabric!(id)
    render(conn, "show.json", fabric: fabric)
  end

end
