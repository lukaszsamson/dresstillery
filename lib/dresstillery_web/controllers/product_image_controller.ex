defmodule DresstilleryWeb.ProductImageController do
  use DresstilleryWeb, :controller

  alias Dresstillery.Products
  alias Dresstillery.Media
  alias Dresstillery.Products.ProductImage

  defp get_images(product_id) do
    product_images = Products.list_product_images(product_id)
    |> Enum.map(& &1.image_id)

    Media.list_images()
    |> Enum.filter(& not(&1.id in product_images))
    |> Enum.map(& {&1.id, &1.id})
  end

  def index(conn, %{"product_id" => product_id}) do
    product_images = Products.list_product_images(product_id)
    render(conn, "index.html", product_id: product_id, product_images: product_images)
  end

  def new(conn, %{"product_id" => product_id}) do
    changeset = Products.change_product_image(product_id, %ProductImage{})
    render(conn, "new.html", product_id: product_id, available_images: get_images(product_id), changeset: changeset)
  end

  def create(conn, %{"product_id" => product_id, "product_image" => product_image_params}) do
    case Products.create_product_image(product_id, product_image_params) do
      {:ok, product_image} ->
        conn
        |> put_flash(:info, "Product image created successfully.")
        |> redirect(to: product_image_path(conn, :show, product_id, product_image))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", product_id: product_id, available_images: get_images(product_id), changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    product_image = Products.get_product_image!(id)
    render(conn, "show.html", product_image: product_image)
  end

  def edit(conn, %{"id" => id}) do
    product_image = Products.get_product_image!(id)
    changeset = Products.change_product_image(product_image)
    render(conn, "edit.html", product_image: product_image, available_images: get_images(product_image.product_id), changeset: changeset)
  end

  def update(conn, %{"id" => id, "product_image" => product_image_params}) do
    product_image = Products.get_product_image!(id)

    case Products.update_product_image(product_image, product_image_params) do
      {:ok, product_image} ->
        conn
        |> put_flash(:info, "Product image updated successfully.")
        |> redirect(to: product_image_path(conn, :show, product_image.product_id, product_image))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", product_image: product_image, available_images: get_images(product_image.product_id), changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    product_image = Products.get_product_image!(id)
    {:ok, _product_image} = Products.delete_product_image(product_image)

    conn
    |> put_flash(:info, "Product image deleted successfully.")
    |> redirect(to: product_image_path(conn, :index, product_image.product_id))
  end
end
