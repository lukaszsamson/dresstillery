defmodule DresstilleryWeb.Api.ProductController do
  use DresstilleryWeb, :controller

  alias Dresstillery.Products

  action_fallback DresstilleryWeb.FallbackController

  def index(conn, _params) do
    products = if conn.assigns[:current_user], do: Products.list_products(), else: Products.list_visible_products()
    render(conn, "index.json", products: products)
  end

  def show(conn, %{"id" => id}) do
    product = if conn.assigns[:current_user], do: Products.get_product!(id), else: Products.get_visible_product!(id)
    render(conn, "show.json", product: product)
  end

end
