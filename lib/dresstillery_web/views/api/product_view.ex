defmodule DresstilleryWeb.Api.ProductView do
  use DresstilleryWeb, :view
  alias DresstilleryWeb.Api.ProductView
  alias DresstilleryWeb.Api.ProductPartView

  def render("index.json", %{products: products}) do
    %{data: render_many(products, ProductView, "product.json")}
  end

  def render("show.json", %{product: product}) do
    %{data: render_one(product, ProductView, "product.json")}
  end

  def render("product.json", %{product: product}) do
    %{id: product.id,
      name: product.product_type.name,
      code: product.product_type.code,
      short_description: product.product_type.short_description,
      main_description: product.product_type.main_description,
      specific_description: product.specific_description,
      price: product.price |> Decimal.to_float,
      parts: render_many(product.parts, ProductPartView, "product_part.json"),
      lenght: product.lenght,
      images: product.images |> Enum.map(& &1.image |> DresstilleryWeb.ImageView.image_src)
    }
  end

end
