defmodule DresstilleryWeb.FabricControllerTest do
  use DresstilleryWeb.AuthorizedConnCase

  alias Dresstillery.Dictionaries

  @create_attrs %{description: "some description", name: "some name"}
  @update_attrs %{description: "some updated description", name: "some updated name"}
  @invalid_attrs %{description: nil, name: nil}

  def fixture(:fabric) do
    {:ok, fabric} = Dictionaries.create_fabric(@create_attrs)
    fabric
  end

  describe "index" do
    test "lists all fabrics", %{conn: conn} do
      conn = get conn, fabric_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Fabrics"
    end
  end

  describe "new fabric" do
    test "renders form", %{conn: conn} do
      conn = get conn, fabric_path(conn, :new)
      assert html_response(conn, 200) =~ "New Fabric"
    end
  end

  describe "create fabric" do
    test "redirects to show when data is valid", %{conn: conn_orig} do
      conn = post conn_orig, fabric_path(conn_orig, :create), fabric: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == fabric_path(conn, :show, id)

      conn = get conn_orig, fabric_path(conn_orig, :show, id)
      assert html_response(conn, 200) =~ "Show Fabric"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, fabric_path(conn, :create), fabric: @invalid_attrs
      assert html_response(conn, 200) =~ "New Fabric"
    end
  end

  describe "edit fabric" do
    setup [:create_fabric]

    test "renders form for editing chosen fabric", %{conn: conn, fabric: fabric} do
      conn = get conn, fabric_path(conn, :edit, fabric)
      assert html_response(conn, 200) =~ "Edit Fabric"
    end
  end

  describe "update fabric" do
    setup [:create_fabric]

    test "redirects when data is valid", %{conn: conn_orig, fabric: fabric} do
      conn = put conn_orig, fabric_path(conn_orig, :update, fabric), fabric: @update_attrs
      assert redirected_to(conn) == fabric_path(conn, :show, fabric)

      conn = get conn_orig, fabric_path(conn_orig, :show, fabric)
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, fabric: fabric} do
      conn = put conn, fabric_path(conn, :update, fabric), fabric: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Fabric"
    end
  end

  describe "delete fabric" do
    setup [:create_fabric]

    test "deletes chosen fabric", %{conn: conn_orig, fabric: fabric} do
      conn = delete conn_orig, fabric_path(conn_orig, :delete, fabric)
      assert redirected_to(conn) == fabric_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn_orig, fabric_path(conn_orig, :show, fabric)
      end
    end
  end

  defp create_fabric(_) do
    fabric = fixture(:fabric)
    {:ok, fabric: fabric}
  end
end
