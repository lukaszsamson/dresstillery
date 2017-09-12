defmodule Dresstillery.DictionariesTest do
  use Dresstillery.DataCase

  alias Dresstillery.Dictionaries

  describe "fabrics" do
    alias Dresstillery.Dictionaries.Fabric

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
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
      assert Dictionaries.list_fabrics() == [fabric]
    end

    test "get_fabric!/1 returns the fabric with given id" do
      fabric = fabric_fixture()
      assert Dictionaries.get_fabric!(fabric.id) == fabric
    end

    test "create_fabric/1 with valid data creates a fabric" do
      assert {:ok, %Fabric{} = fabric} = Dictionaries.create_fabric(@valid_attrs)
      assert fabric.description == "some description"
      assert fabric.name == "some name"
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
    end

    test "update_fabric/2 with invalid data returns error changeset" do
      fabric = fabric_fixture()
      assert {:error, %Ecto.Changeset{}} = Dictionaries.update_fabric(fabric, @invalid_attrs)
      assert fabric == Dictionaries.get_fabric!(fabric.id)
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
end
