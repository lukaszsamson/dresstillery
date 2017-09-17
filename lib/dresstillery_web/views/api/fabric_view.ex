defmodule DresstilleryWeb.Api.FabricView do
  use DresstilleryWeb, :view
  alias DresstilleryWeb.Api.FabricView
  alias DresstilleryWeb.Api.IngridientView

  def render("index.json", %{fabrics: fabrics}) do
    %{data: render_many(fabrics, FabricView, "fabric.json")}
  end

  def render("show.json", %{fabric: fabric}) do
    %{data: render_one(fabric, FabricView, "fabric.json")}
  end

  def render("fabric.json", %{fabric: fabric}) do
    %{id: fabric.id,
      name: fabric.name,
      code: fabric.code,
      available: fabric.available,
      description: fabric.description,
      images: fabric.images
      |> Enum.sort_by(& &1.order)
      |> Enum.map(& &1.image |> DresstilleryWeb.ImageView.image_src),
      ingridients: render_many(fabric.ingridients, IngridientView, "ingridient.json"),
    }
  end
end
