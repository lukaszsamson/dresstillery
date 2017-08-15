defmodule DresstilleryWeb.ProductControllerTest do
  use DresstilleryWeb.AuthorizedConnCase

  alias Dresstillery.Products

  @create_attrs %{specific_description: "some code", price: "120.5"}
  @update_attrs %{specific_description: "some updated code", price: "456.7"}
  @invalid_attrs %{specific_description: nil, price: nil}

  setup do
    {:ok, product_type} = Products.create_product_type(%{code: "some code", main_description: "some main_description", name: "some name", short_description: "some short_description"})
    {:ok, %{product_type: product_type}}
  end

  def fixture(product_type, :product) do
    {:ok, product} = Products.create_product(@create_attrs |> Map.put(:product_type_id, product_type.id))
    product
  end

  describe "index" do
    test "lists all products", %{conn: conn} do
      conn = get conn, product_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Products"
    end
  end

  describe "new product" do
    test "renders form", %{conn: conn} do
      conn = get conn, product_path(conn, :new)
      assert html_response(conn, 200) =~ "New Product"
    end
  end

  describe "create product" do
    test "redirects to show when data is valid", %{conn: conn_orig, product_type: product_type} do
      conn = post conn_orig, product_path(conn_orig, :create), product: @create_attrs |> Map.put(:product_type_id, product_type.id)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == product_path(conn, :show, id)

      conn = get conn_orig, product_path(conn_orig, :show, id)
      assert html_response(conn, 200) =~ "Show Product"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, product_path(conn, :create), product: @invalid_attrs
      assert html_response(conn, 200) =~ "New Product"
    end
  end

  describe "edit product" do
    setup [:create_product]

    test "renders form for editing chosen product", %{conn: conn, product: product} do
      conn = get conn, product_path(conn, :edit, product)
      assert html_response(conn, 200) =~ "Edit Product"
    end
  end

  describe "update product" do
    setup [:create_product]

    test "redirects when data is valid", %{conn: conn_orig, product: product, product_type: product_type} do
      conn = put conn_orig, product_path(conn_orig, :update, product), product: (@update_attrs |> Map.put(:product_type_id, product_type.id))
      assert redirected_to(conn) == product_path(conn, :show, product)

      conn = get conn_orig, product_path(conn_orig, :show, product)
      assert html_response(conn, 200) =~ "some updated code"
    end

    test "renders errors when data is invalid", %{conn: conn, product: product} do
      conn = put conn, product_path(conn, :update, product), product: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Product"
    end
  end

  describe "delete product" do
    setup [:create_product]

    test "deletes chosen product", %{conn: conn_orig, product: product} do
      conn = delete conn_orig, product_path(conn_orig, :delete, product)
      assert redirected_to(conn) == product_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn_orig, product_path(conn_orig, :show, product)
      end
    end
  end

  defp create_product(%{product_type: product_type}) do
    product = fixture(product_type, :product)
    {:ok, product: product}
  end
end
