defmodule DresstilleryWeb.FabricImageControllerTest do
  use DresstilleryWeb.AuthorizedConnCase

  alias Dresstillery.Dictionaries
  alias Dresstillery.Media

  @create_attrs %{order: 42}
  @update_attrs %{order: 43}
  @invalid_attrs %{order: nil}

  setup do
    {:ok, fabric} = Dictionaries.create_fabric(%{name: "some name", description: "some description"})
    {:ok, image} = Media.create_image(%{path: "some path"})
    {:ok, fabric: fabric, image: image}
  end

  def fixture(:fabric_image, fabric, image) do
    {:ok, fabric_image} = Dictionaries.create_fabric_image(fabric.id, @create_attrs |> Map.put(:image_id, image.id))
    fabric_image
  end

  describe "index" do
    test "lists all fabric_images", %{conn: conn, fabric: fabric} do
      conn = get conn, fabric_image_path(conn, :index, fabric.id)
      assert html_response(conn, 200) =~ "Listing Fabric images"
    end
  end

  describe "new fabric_image" do
    test "renders form", %{conn: conn, fabric: fabric} do
      conn = get conn, fabric_image_path(conn, :new, fabric.id)
      assert html_response(conn, 200) =~ "New Fabric image"
    end
  end

  describe "create fabric_image" do
    test "redirects to show when data is valid", %{conn: conn_orig, fabric: fabric, image: image} do
      conn = post conn_orig, fabric_image_path(conn_orig, :create, fabric.id), fabric_image: @create_attrs |> Map.put(:image_id, image.id)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == fabric_image_path(conn, :show, fabric.id, id)

      conn = get conn_orig, fabric_image_path(conn_orig, :show, fabric.id, id)
      assert html_response(conn, 200) =~ "Show Fabric image"
    end

    test "renders errors when data is invalid", %{conn: conn, fabric: fabric} do
      conn = post conn, fabric_image_path(conn, :create, fabric.id), fabric_image: @invalid_attrs
      assert html_response(conn, 200) =~ "New Fabric image"
    end
  end

  describe "edit fabric_image" do
    setup [:create_fabric_image]

    test "renders form for editing chosen fabric_image", %{conn: conn, fabric_image: fabric_image} do
      conn = get conn, fabric_image_path(conn, :edit, fabric_image.fabric_id, fabric_image)
      assert html_response(conn, 200) =~ "Edit Fabric image"
    end
  end

  describe "update fabric_image" do
    setup [:create_fabric_image]

    test "redirects when data is valid", %{conn: conn_orig, fabric_image: fabric_image} do
      conn = put conn_orig, fabric_image_path(conn_orig, :update, fabric_image.fabric_id, fabric_image), fabric_image: @update_attrs
      assert redirected_to(conn) == fabric_image_path(conn, :show, fabric_image.fabric_id, fabric_image)

      conn = get conn_orig, fabric_image_path(conn_orig, :show, fabric_image.fabric_id, fabric_image)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, fabric_image: fabric_image} do
      conn = put conn, fabric_image_path(conn, :update, fabric_image.fabric_id, fabric_image), fabric_image: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Fabric image"
    end
  end

  describe "delete fabric_image" do
    setup [:create_fabric_image]

    test "deletes chosen fabric_image", %{conn: conn_orig, fabric_image: fabric_image} do
      conn = delete conn_orig, fabric_image_path(conn_orig, :delete, fabric_image.fabric_id, fabric_image)
      assert redirected_to(conn) == fabric_image_path(conn, :index, fabric_image.fabric_id)
      assert_error_sent 404, fn ->
        get conn_orig, fabric_image_path(conn_orig, :show, fabric_image.fabric_id, fabric_image)
      end
    end
  end

  defp create_fabric_image(%{fabric: fabric, image: image}) do
    fabric_image = fixture(:fabric_image, fabric, image)
    {:ok, fabric_image: fabric_image, fabric: fabric, image: image}
  end
end
