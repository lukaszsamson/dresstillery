defmodule DresstilleryWeb.Api.FabricControllerTest do
  use DresstilleryWeb.ConnCase

  alias Dresstillery.Dictionaries
  alias Dresstillery.Dictionaries.Fabric
  alias Dresstillery.Media

  @create_attrs %{description: "some description", name: "some name", code: "some code",
  available: false, hidden: false,
  ingridients: [%{name: "cotton", percentage: 25}]}

  def fixture(:fabric) do
    {:ok, image} = Media.create_image(%{path: "some path", file_name: "some name"})
    {:ok, fabric} = Dictionaries.create_fabric(@create_attrs)
    {:ok, _fi} = Dictionaries.create_fabric_image(fabric.id, %{order: 1, image_id: image.id})
    fabric
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all fabrics", %{conn: conn} do
      conn = get conn, api_fabric_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "show fabric" do
    setup [:create_fabric]

    test "renders fabric when data is valid", %{conn: conn, fabric: %Fabric{id: id}} do
      conn = get conn, api_fabric_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "description" => "some description",
        "name" => "some name",
        "code" => "some code",
        "available" => false,
        "images" => ["/media/some path"],
        "ingridients" => [%{"name" => "cotton", "percentage" => 25}],
        "hidden" => false,
      }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      assert_error_sent 404, fn ->
        get conn, api_fabric_path(conn, :show, -1)
      end
    end
  end

  defp create_fabric(_) do
    fabric = fixture(:fabric)
    {:ok, fabric: fabric}
  end
end
