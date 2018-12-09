defmodule DresstilleryWeb.ProductTypeController do
  use DresstilleryWeb, :controller

  alias Dresstillery.Products
  alias Dresstillery.Products.ProductType

  def index(conn, _params) do
    product_types = Products.list_product_types()
    render(conn, "index.html", product_types: product_types)
  end

  def new(conn, _params) do
    changeset = Products.change_product_type(%ProductType{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"product_type" => product_type_params}) do
    case Products.create_product_type(product_type_params) do
      {:ok, product_type} ->
        conn
        |> put_flash(:info, "Product type created successfully.")
        |> redirect(to: Routes.product_type_path(conn, :show, product_type))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    product_type = Products.get_product_type!(id)
    render(conn, "show.html", product_type: product_type)
  end

  def edit(conn, %{"id" => id}) do
    product_type = Products.get_product_type!(id)
    changeset = Products.change_product_type(product_type)
    render(conn, "edit.html", product_type: product_type, changeset: changeset)
  end

  def update(conn, %{"id" => id, "product_type" => product_type_params}) do
    product_type = Products.get_product_type!(id)

    case Products.update_product_type(product_type, product_type_params) do
      {:ok, product_type} ->
        conn
        |> put_flash(:info, "Product type updated successfully.")
        |> redirect(to: Routes.product_type_path(conn, :show, product_type))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", product_type: product_type, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    product_type = Products.get_product_type!(id)
    {:ok, _product_type} = Products.delete_product_type(product_type)

    conn
    |> put_flash(:info, "Product type deleted successfully.")
    |> redirect(to: Routes.product_type_path(conn, :index))
  end
end
