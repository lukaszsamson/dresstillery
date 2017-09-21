defmodule DresstilleryWeb.Api.FabricController do
  use DresstilleryWeb, :controller

  alias Dresstillery.Dictionaries

  action_fallback DresstilleryWeb.FallbackController

  def index(conn, _params) do
    fabrics = if conn.assigns[:current_user], do: Dictionaries.list_fabrics(), else: Dictionaries.list_visible_fabrics()
    render(conn, "index.json", fabrics: fabrics)
  end

  def show(conn, %{"id" => id}) do
    fabric = if conn.assigns[:current_user], do: Dictionaries.get_fabric!(id), else: Dictionaries.get_visible_fabric!(id)
    render(conn, "show.json", fabric: fabric)
  end

end
