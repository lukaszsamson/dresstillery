defmodule DresstilleryWeb.Api.ProductPartView do
  use DresstilleryWeb, :view
  alias DresstilleryWeb.Api.IngridientView

  def render("product_part.json", %{product_part: product_part}) do
    %{name: product_part.name,
      ingridients: render_many(product_part.ingridients, IngridientView, "ingridient.json"),
    }
  end
end
