defmodule DresstilleryWeb.Api.FabricControllerTest do
  use DresstilleryWeb.ConnCase

  alias Dresstillery.Dictionaries
  alias Dresstillery.Dictionaries.Fabric

  @create_attrs %{description: "some description", name: "some name"}

  def fixture(:fabric) do
    {:ok, fabric} = Dictionaries.create_fabric(@create_attrs)
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
        "name" => "some name"}
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
