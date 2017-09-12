defmodule DresstilleryWeb.Api.FabricView do
  use DresstilleryWeb, :view
  alias DresstilleryWeb.Api.FabricView

  def render("index.json", %{fabrics: fabrics}) do
    %{data: render_many(fabrics, FabricView, "fabric.json")}
  end

  def render("show.json", %{fabric: fabric}) do
    %{data: render_one(fabric, FabricView, "fabric.json")}
  end

  def render("fabric.json", %{fabric: fabric}) do
    %{id: fabric.id,
      name: fabric.name,
      description: fabric.description}
  end
end
