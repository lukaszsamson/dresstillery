defmodule DresstilleryWeb.ProductImageControllerTest do
  use DresstilleryWeb.AuthorizedConnCase

  alias Dresstillery.Products
  alias Dresstillery.Media

  @create_attrs %{order: 42}
  @update_attrs %{order: 43}
  @invalid_attrs %{order: nil}

  setup do
    {:ok, product_type} = Products.create_product_type(%{code: "some code", main_description: "some main_description",
    name: "some name", short_description: "some short_description"})
    {:ok, product} = Products.create_product(%{specific_description: "some code", price: "120.5", product_type_id: product_type.id,
    lenght: 25,
    available: true, hidden: false,})
    {:ok, image} = Media.create_image(%{path: "some path"})
    {:ok, product: product, image: image}
  end

  def fixture(:product_image, product, image) do
    {:ok, product_image} = Products.create_product_image(product.id, @create_attrs |> Map.put(:image_id, image.id))
    product_image
  end

  describe "index" do
    test "lists all product_images", %{conn: conn, product: product} do
      conn = get conn, product_image_path(conn, :index, product.id)
      assert html_response(conn, 200) =~ "Listing Product images"
    end
  end

  describe "new product_image" do
    test "renders form", %{conn: conn, product: product} do
      conn = get conn, product_image_path(conn, :new, product.id)
      assert html_response(conn, 200) =~ "New Product image"
    end
  end

  describe "create product_image" do
    test "redirects to show when data is valid", %{conn: conn_orig, product: product, image: image} do
      conn = post conn_orig, product_image_path(conn_orig, :create, product.id), product_image: @create_attrs |> Map.put(:image_id, image.id)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == product_image_path(conn, :show, product.id, id)

      conn = get conn_orig, product_image_path(conn_orig, :show, product.id, id)
      assert html_response(conn, 200) =~ "Show Product image"
    end

    test "renders errors when data is invalid", %{conn: conn, product: product} do
      conn = post conn, product_image_path(conn, :create, product.id), product_image: @invalid_attrs
      assert html_response(conn, 200) =~ "New Product image"
    end
  end

  describe "edit product_image" do
    setup [:create_product_image]

    test "renders form for editing chosen product_image", %{conn: conn, product_image: product_image} do
      conn = get conn, product_image_path(conn, :edit, product_image.product_id, product_image)
      assert html_response(conn, 200) =~ "Edit Product image"
    end
  end

  describe "update product_image" do
    setup [:create_product_image]

    test "redirects when data is valid", %{conn: conn_orig, product_image: product_image} do
      conn = put conn_orig, product_image_path(conn_orig, :update, product_image.product_id, product_image), product_image: @update_attrs
      assert redirected_to(conn) == product_image_path(conn, :show, product_image.product_id, product_image)

      conn = get conn_orig, product_image_path(conn_orig, :show, product_image.product_id, product_image)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, product_image: product_image} do
      conn = put conn, product_image_path(conn, :update, product_image.product_id, product_image), product_image: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Product image"
    end
  end

  describe "delete product_image" do
    setup [:create_product_image]

    test "deletes chosen product_image", %{conn: conn_orig, product_image: product_image} do
      conn = delete conn_orig, product_image_path(conn_orig, :delete, product_image.product_id, product_image)
      assert redirected_to(conn) == product_image_path(conn, :index, product_image.product_id)
      assert_error_sent 404, fn ->
        get conn_orig, product_image_path(conn_orig, :show, product_image.product_id, product_image)
      end
    end
  end

  defp create_product_image(%{product: product, image: image}) do
    product_image = fixture(:product_image, product, image)
    {:ok, product_image: product_image, product: product, image: image}
  end
end
