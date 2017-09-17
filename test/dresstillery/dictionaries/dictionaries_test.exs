defmodule Dresstillery.DictionariesTest do
  use Dresstillery.DataCase

  alias Dresstillery.Dictionaries

  describe "fabrics" do
    alias Dresstillery.Dictionaries.Fabric

    @valid_attrs %{description: "some description", name: "some name", code: "some code",
    available: true, hidden: false,
    ingridients: [%{name: "cotton", percentage: 25}]}
    @update_attrs %{description: "some updated description", name: "some updated name", code: "some updated code",
    available: false, hidden: true,
    ingridients: [%{name: "wool", percentage: 35}]}
    @invalid_attrs %{description: nil, name: nil}

    def fabric_fixture(attrs \\ %{}) do
      {:ok, fabric} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Dictionaries.create_fabric()

      fabric
    end

    test "list_fabrics/0 returns all fabrics" do
      fabric = fabric_fixture()
      assert [f] = Dictionaries.list_fabrics()
      assert f.id == fabric.id
    end

    test "get_fabric!/1 returns the fabric with given id" do
      fabric = fabric_fixture()
      f = Dictionaries.get_fabric!(fabric.id)
      assert f.id == fabric.id
    end

    test "create_fabric/1 with valid data creates a fabric" do
      assert {:ok, %Fabric{} = fabric} = Dictionaries.create_fabric(@valid_attrs)
      assert fabric.description == "some description"
      assert fabric.name == "some name"
      assert fabric.code == "some code"
      assert fabric.available
      refute fabric.hidden
      assert [ing] = fabric.ingridients
      assert ing.name == "cotton"
      assert ing.percentage == 25
    end

    test "create_fabric/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dictionaries.create_fabric(@invalid_attrs)
    end

    test "update_fabric/2 with valid data updates the fabric" do
      fabric = fabric_fixture()
      assert {:ok, fabric} = Dictionaries.update_fabric(fabric, @update_attrs)
      assert %Fabric{} = fabric
      assert fabric.description == "some updated description"
      assert fabric.name == "some updated name"
      assert fabric.code == "some updated code"
      refute fabric.available
      assert fabric.hidden
      assert [ing] = fabric.ingridients
      assert ing.name == "wool"
      assert ing.percentage == 35
    end

    test "update_fabric/2 with invalid data returns error changeset" do
      fabric = fabric_fixture()
      assert {:error, %Ecto.Changeset{}} = Dictionaries.update_fabric(fabric, @invalid_attrs)
    end

    test "delete_fabric/1 deletes the fabric" do
      fabric = fabric_fixture()
      assert {:ok, %Fabric{}} = Dictionaries.delete_fabric(fabric)
      assert_raise Ecto.NoResultsError, fn -> Dictionaries.get_fabric!(fabric.id) end
    end

    test "change_fabric/1 returns a fabric changeset" do
      fabric = fabric_fixture()
      assert %Ecto.Changeset{} = Dictionaries.change_fabric(fabric)
    end
  end

  describe "fabric_images" do
    alias Dresstillery.Dictionaries.FabricImage
    alias Dresstillery.Media

    @valid_attrs %{order: 42}
    @update_attrs %{order: 43}
    @invalid_attrs %{order: nil}

    setup do
      {:ok, fabric} = Dictionaries.create_fabric(%{name: "some name", description: "some description", code: "some code",
      available: true, hidden: false,})
      {:ok, image} = Media.create_image(%{path: "some path", file_name: "some name"})
      {:ok, image1} = Media.create_image(%{path: "some path", file_name: "some name"})
      {:ok, fabric: fabric, image: image, image1: image1}
    end

    def fabric_image_fixture(fabric, image, attrs \\ %{}) do
      attrs = attrs
      |> Map.put(:image_id, image.id)
      |> Enum.into(@valid_attrs)

      {:ok, fabric_image} = Dictionaries.create_fabric_image(fabric.id, attrs)

      fabric_image
    end

    test "list_fabric_images/1 returns all fabric_images for fabric", %{fabric: fabric, image: image} do
      fabric_image = fabric_image_fixture(fabric, image)
      assert [pi] = Dictionaries.list_fabric_images(fabric.id)
      assert pi.id == fabric_image.id
    end

    test "get_fabric_image!/1 returns the fabric_image with given id", %{fabric: fabric, image: image} do
      fabric_image = fabric_image_fixture(fabric, image)
      assert pi = Dictionaries.get_fabric_image!(fabric_image.id)
      assert pi.id == fabric_image.id
    end

    test "create_fabric_image/2 with valid data creates a fabric_image", %{fabric: fabric, image: image} do
      assert {:ok, %FabricImage{} = fabric_image} = Dictionaries.create_fabric_image(fabric.id, @valid_attrs |> Map.put(:image_id, image.id))
      assert fabric_image.order == 42
    end

    test "create_fabric_image/2 with invalid data returns error changeset", %{fabric: fabric} do
      assert {:error, %Ecto.Changeset{}} = Dictionaries.create_fabric_image(fabric.id, @invalid_attrs)
    end

    test "create_fabric_image/2 with the same image returns error changeset", %{fabric: fabric, image: image} do
      assert {:ok, %FabricImage{}} = Dictionaries.create_fabric_image(fabric.id, @valid_attrs |> Map.put(:image_id, image.id))
      assert {:error, %Ecto.Changeset{}} = Dictionaries.create_fabric_image(fabric.id, @update_attrs |> Map.put(:image_id, image.id))
    end

    test "create_fabric_image/2 with the same order returns error changeset", %{fabric: fabric, image: image, image1: image1} do
      assert {:ok, %FabricImage{}} = Dictionaries.create_fabric_image(fabric.id, @valid_attrs |> Map.put(:image_id, image.id))
      assert {:error, %Ecto.Changeset{}} = Dictionaries.create_fabric_image(fabric.id, @valid_attrs |> Map.put(:image_id, image1.id))
    end

    test "create_fabric_image/2 with different order and image returns error changeset", %{fabric: fabric, image: image, image1: image1} do
      assert {:ok, %FabricImage{}} = Dictionaries.create_fabric_image(fabric.id, @valid_attrs |> Map.put(:image_id, image.id))
      assert {:ok, %FabricImage{}} = Dictionaries.create_fabric_image(fabric.id, @update_attrs |> Map.put(:image_id, image1.id))
    end

    test "update_fabric_image/2 with valid data updates the fabric_image", %{fabric: fabric, image: image} do
      fabric_image = fabric_image_fixture(fabric, image)
      assert {:ok, fabric_image} = Dictionaries.update_fabric_image(fabric_image, @update_attrs)
      assert %FabricImage{} = fabric_image
      assert fabric_image.order == 43
    end

    test "update_fabric_image/2 with invalid data returns error changeset", %{fabric: fabric, image: image} do
      fabric_image = fabric_image_fixture(fabric, image)
      assert {:error, %Ecto.Changeset{}} = Dictionaries.update_fabric_image(fabric_image, @invalid_attrs)
    end

    test "delete_fabric_image/1 deletes the fabric_image", %{fabric: fabric, image: image} do
      fabric_image = fabric_image_fixture(fabric, image)
      assert {:ok, %FabricImage{}} = Dictionaries.delete_fabric_image(fabric_image)
      assert_raise Ecto.NoResultsError, fn -> Dictionaries.get_fabric_image!(fabric_image.id) end
    end

    test "change_fabric_image/1 returns a fabric_image changeset", %{fabric: fabric, image: image} do
      fabric_image = fabric_image_fixture(fabric, image)
      assert %Ecto.Changeset{} = Dictionaries.change_fabric_image(fabric_image)
    end

    test "change_fabric_image/2 returns a fabric_image changeset", %{fabric: fabric} do
      fabric_image = %FabricImage{}
      assert %Ecto.Changeset{} = Dictionaries.change_fabric_image(fabric.id, fabric_image)
    end
  end
end
