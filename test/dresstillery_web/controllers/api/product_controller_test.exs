defmodule DresstilleryWeb.Api.ProductControllerTest do
  use DresstilleryWeb.ConnCase

  alias Dresstillery.Products
  alias Dresstillery.Products.Product

  @create_attrs %{specific_description: "some code", price: "120.5"}

  def fixture(:product) do
    {:ok, product_type} = Products.create_product_type(%{code: "some code", main_description: "some main_description", name: "some name", short_description: "some short_description"})
    {:ok, product} = Products.create_product(@create_attrs |> Map.put(:product_type_id, product_type.id))
    product
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all products", %{conn: conn} do
      conn = get conn, api_product_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "show product" do
    setup [:create_product]

    test "renders product when id", %{conn: conn, product: %Product{id: id}} do
      conn = get conn, api_product_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "code" => "some code",
        "name" => "some name",
        "short_description" => "some short_description",
        "main_description" => "some main_description",
        "specific_description" => "some code",
        "price" => 120.5,
        "images" => [],
        "ingridients" => [],
        "lenghts" => [],
      }
    end

    test "renders errors when id is invalid", %{conn: conn} do
      assert_error_sent 404, fn ->
        get conn, api_product_path(conn, :show, 0)
      end
    end
  end


  defp create_product(_) do
    product = fixture(:product)
    {:ok, product: product}
  end
end
