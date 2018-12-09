defmodule DresstilleryWeb.ProductController do
  use DresstilleryWeb, :controller

  alias Dresstillery.Products
  alias Dresstillery.Products.Product

  defp get_product_types() do
    Products.list_product_types()
    |> Enum.map(& {&1.name, &1.id})
  end

  def parts_to_string(parts) do
    parts
    |> Enum.map(& "#{&1.name}:#{&1.ingridients |> ingridients_to_string}")
    |> Enum.join(";")
  end

  def ingridients_to_string(ingridients) do
    ingridients
    |> Enum.map(& "#{&1.name}-#{&1.percentage}")
    |> Enum.join(",")
  end

  def ingridients_from_string(nil), do: []
  def ingridients_from_string(ingridients) do
    ingridients
    |> String.split(",")
    |> Enum.map(fn ing ->
      spli = ing |> String.split("-")
      %{"name" => spli |> Enum.at(0), "percentage" => spli |> Enum.at(1)}
    end)
  end

  def parts_from_string(nil), do: []
  def parts_from_string(str) do
    str
    |> String.split(";")
    |> Enum.map(fn pa ->
      spli = pa |> String.split(":")
      %{"name" => spli |> Enum.at(0), "ingridients" => spli |> Enum.at(1) |> ingridients_from_string}
    end)
  end

  defp prepare_parts(product_params) do
    product_params
    |> Map.put("parts", parts_from_string product_params["parts_string"])
  end

  def index(conn, _params) do
    products = Products.list_products()
    render(conn, "index.html", products: products)
  end

  def new(conn, _params) do
    changeset = Products.change_product(%Product{})
    render(conn, "new.html", changeset: changeset, available_product_types: get_product_types())
  end

  def create(conn, %{"product" => product_params}) do
    product_params = prepare_parts product_params

    case Products.create_product(product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product created successfully.")
        |> redirect(to: Routes.product_path(conn, :show, product))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, available_product_types: get_product_types())
    end
  end

  def show(conn, %{"id" => id}) do
    product = Products.get_product!(id)
    render(conn, "show.html", product: product)
  end

  def edit(conn, %{"id" => id}) do
    product = Products.get_product!(id)
    product = product
    |> Map.put(:parts_string, parts_to_string(product.parts))
    changeset = Products.change_product(product)
    render(conn, "edit.html", product: product, changeset: changeset, available_product_types: get_product_types())
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Products.get_product!(id)

    product_params = prepare_parts product_params

    case Products.update_product(product, product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product updated successfully.")
        |> redirect(to: Routes.product_path(conn, :show, product))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", product: product, changeset: changeset, available_product_types: get_product_types())
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Products.get_product!(id)
    {:ok, _product} = Products.delete_product(product)

    conn
    |> put_flash(:info, "Product deleted successfully.")
    |> redirect(to: Routes.product_path(conn, :index))
  end
end
