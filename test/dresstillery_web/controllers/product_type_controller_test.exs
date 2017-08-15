defmodule DresstilleryWeb.ProductTypeControllerTest do
  use DresstilleryWeb.AuthorizedConnCase

  alias Dresstillery.Products

  @create_attrs %{code: "some code", main_description: "some main_description",
  name: "some name", short_description: "some short_description", ingridients: [%{name: "cotton", percentage: 25}]}
  @update_attrs %{code: "some updated code", main_description: "some updated main_description",
  name: "some updated name", short_description: "some updated short_description", ingridients: [%{name: "cotton", percentage: 25}]}
  @invalid_attrs %{code: nil, main_description: nil, name: nil, short_description: nil}

  def fixture(:product_type) do
    {:ok, product_type} = Products.create_product_type(@create_attrs)
    product_type
  end

  describe "index" do
    test "lists all product_types", %{conn: conn} do
      conn = get conn, product_type_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Product types"
    end
  end

  describe "new product_type" do
    test "renders form", %{conn: conn} do
      conn = get conn, product_type_path(conn, :new)
      assert html_response(conn, 200) =~ "New Product type"
    end
  end

  describe "create product_type" do
    test "redirects to show when data is valid", %{conn: conn_orig} do
      conn = post conn_orig, product_type_path(conn_orig, :create), product_type: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == product_type_path(conn, :show, id)

      conn = get conn_orig, product_type_path(conn_orig, :show, id)
      assert html_response(conn, 200) =~ "Show Product type"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, product_type_path(conn, :create), product_type: @invalid_attrs
      assert html_response(conn, 200) =~ "New Product type"
    end
  end

  describe "edit product_type" do
    setup [:create_product_type]

    test "renders form for editing chosen product_type", %{conn: conn, product_type: product_type} do
      conn = get conn, product_type_path(conn, :edit, product_type)
      assert html_response(conn, 200) =~ "Edit Product type"
    end
  end

  describe "update product_type" do
    setup [:create_product_type]

    test "redirects when data is valid", %{conn: conn_orig, product_type: product_type} do
      conn = put conn_orig, product_type_path(conn_orig, :update, product_type), product_type: @update_attrs
      assert redirected_to(conn) == product_type_path(conn, :show, product_type)

      conn = get conn_orig, product_type_path(conn_orig, :show, product_type)
      assert html_response(conn, 200) =~ "some updated code"
    end

    test "renders errors when data is invalid", %{conn: conn, product_type: product_type} do
      conn = put conn, product_type_path(conn, :update, product_type), product_type: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Product type"
    end
  end

  describe "delete product_type" do
    setup [:create_product_type]

    test "deletes chosen product_type", %{conn: conn_orig, product_type: product_type} do
      conn = delete conn_orig, product_type_path(conn_orig, :delete, product_type)
      assert redirected_to(conn) == product_type_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn_orig, product_type_path(conn_orig, :show, product_type)
      end
    end
  end

  defp create_product_type(_) do
    product_type = fixture(:product_type)
    {:ok, product_type: product_type}
  end
end
