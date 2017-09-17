defmodule Dresstillery.ProductsTest do
  use Dresstillery.DataCase

  alias Dresstillery.Products

  describe "products" do
    alias Dresstillery.Products.Product

    @valid_attrs %{specific_description: "some code", price: "120.5", lenght: 25,
    available: true, hidden: false,
    parts: [%{name: "top", ingridients: [%{name: "cotton", percentage: 25}]}]}
    @update_attrs %{specific_description: "some updated code", price: "456.7", lenght: 26,
    available: false, hidden: true,
    parts: [%{name: "top", ingridients: [%{name: "wool", percentage: 35}]}]}
    @invalid_attrs %{specific_description: nil, price: nil}

    setup do
      {:ok, product_type} = Products.create_product_type(%{code: "some code", main_description: "some main_description", name: "some name", short_description: "some short_description"})
      {:ok, %{product_type: product_type}}
    end

    def product_fixture(product_type, attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.put(:product_type_id, product_type.id)
        |> Products.create_product()

      product
      |> Repo.preload([images: :image, product_type: []])
    end

    test "list_products/0 returns all products", %{product_type: product_type} do
      product = product_fixture(product_type)
      assert Products.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id", %{product_type: product_type} do
      product = product_fixture(product_type)
      assert Products.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product", %{product_type: product_type} do
      assert {:ok, %Product{} = product} = Products.create_product(@valid_attrs |> Map.put(:product_type_id, product_type.id))
      assert product.specific_description == "some code"
      assert product.price == Decimal.new("120.5")
      assert product.lenght == 25
      assert [part] = product.parts
      assert part.name == "top"
      assert [ing] = part.ingridients
      assert ing.name == "cotton"
      assert ing.percentage == 25
      assert product.available
      refute product.hidden
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product", %{product_type: product_type} do
      product = product_fixture(product_type)
      assert {:ok, product} = Products.update_product(product, @update_attrs)
      assert %Product{} = product
      assert product.specific_description == "some updated code"
      assert product.price == Decimal.new("456.7")
      assert product.lenght == 26

      assert [part] = product.parts
      assert part.name == "top"
      assert [ing] = part.ingridients
      assert ing.name == "wool"
      assert ing.percentage == 35

      refute product.available
      assert product.hidden
    end

    test "update_product/2 with invalid data returns error changeset", %{product_type: product_type} do
      product = product_fixture(product_type)
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
      assert product == Products.get_product!(product.id)
    end

    test "delete_product/1 deletes the product", %{product_type: product_type} do
      product = product_fixture(product_type)
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset", %{product_type: product_type}  do
      product = product_fixture(product_type)
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end

  describe "product_images" do
    alias Dresstillery.Products.ProductImage
    alias Dresstillery.Media

    @valid_attrs %{order: 42}
    @update_attrs %{order: 43}
    @invalid_attrs %{order: nil}

    setup do
      {:ok, product_type} = Products.create_product_type(%{code: "some code", main_description: "some main_description", name: "some name", short_description: "some short_description"})
      {:ok, product} = Products.create_product(%{specific_description: "some code", lenght: 25, price: "120.5", product_type_id: product_type.id,
      available: true, hidden: false,})
      {:ok, image} = Media.create_image(%{path: "some path"})
      {:ok, image1} = Media.create_image(%{path: "some path"})
      {:ok, product: product, image: image, image1: image1}
    end

    def product_image_fixture(product, image, attrs \\ %{}) do
      attrs = attrs
      |> Map.put(:image_id, image.id)
      |> Enum.into(@valid_attrs)

      {:ok, product_image} = Products.create_product_image(product.id, attrs)

      product_image
    end

    test "list_product_images/1 returns all product_images for product", %{product: product, image: image} do
      product_image = product_image_fixture(product, image)
      assert [pi] = Products.list_product_images(product.id)
      assert pi.id == product_image.id
    end

    test "get_product_image!/1 returns the product_image with given id", %{product: product, image: image} do
      product_image = product_image_fixture(product, image)
      assert pi = Products.get_product_image!(product_image.id)
      assert pi.id == product_image.id
    end

    test "create_product_image/2 with valid data creates a product_image", %{product: product, image: image} do
      assert {:ok, %ProductImage{} = product_image} = Products.create_product_image(product.id, @valid_attrs |> Map.put(:image_id, image.id))
      assert product_image.order == 42
    end

    test "create_product_image/2 with invalid data returns error changeset", %{product: product} do
      assert {:error, %Ecto.Changeset{}} = Products.create_product_image(product.id, @invalid_attrs)
    end

    test "create_product_image/2 with the same image returns error changeset", %{product: product, image: image} do
      assert {:ok, %ProductImage{}} = Products.create_product_image(product.id, @valid_attrs |> Map.put(:image_id, image.id))
      assert {:error, %Ecto.Changeset{}} = Products.create_product_image(product.id, @update_attrs |> Map.put(:image_id, image.id))
    end

    test "create_product_image/2 with the same order returns error changeset", %{product: product, image: image, image1: image1} do
      assert {:ok, %ProductImage{}} = Products.create_product_image(product.id, @valid_attrs |> Map.put(:image_id, image.id))
      assert {:error, %Ecto.Changeset{}} = Products.create_product_image(product.id, @valid_attrs |> Map.put(:image_id, image1.id))
    end

    test "create_product_image/2 with different order and image returns error changeset", %{product: product, image: image, image1: image1} do
      assert {:ok, %ProductImage{}} = Products.create_product_image(product.id, @valid_attrs |> Map.put(:image_id, image.id))
      assert {:ok, %ProductImage{}} = Products.create_product_image(product.id, @update_attrs |> Map.put(:image_id, image1.id))
    end

    test "update_product_image/2 with valid data updates the product_image", %{product: product, image: image} do
      product_image = product_image_fixture(product, image)
      assert {:ok, product_image} = Products.update_product_image(product_image, @update_attrs)
      assert %ProductImage{} = product_image
      assert product_image.order == 43
    end

    test "update_product_image/2 with invalid data returns error changeset", %{product: product, image: image} do
      product_image = product_image_fixture(product, image)
      assert {:error, %Ecto.Changeset{}} = Products.update_product_image(product_image, @invalid_attrs)
    end

    test "delete_product_image/1 deletes the product_image", %{product: product, image: image} do
      product_image = product_image_fixture(product, image)
      assert {:ok, %ProductImage{}} = Products.delete_product_image(product_image)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product_image!(product_image.id) end
    end

    test "change_product_image/1 returns a product_image changeset", %{product: product, image: image} do
      product_image = product_image_fixture(product, image)
      assert %Ecto.Changeset{} = Products.change_product_image(product_image)
    end

    test "change_product_image/2 returns a product_image changeset", %{product: product} do
      product_image = %ProductImage{}
      assert %Ecto.Changeset{} = Products.change_product_image(product.id, product_image)
    end
  end

  describe "product_types" do
    alias Dresstillery.Products.ProductType

    @valid_attrs %{code: "some code", main_description: "some main_description", name: "some name", short_description: "some short_description"}
    @update_attrs %{code: "some updated code", main_description: "some updated main_description", name: "some updated name", short_description: "some updated short_description"}
    @invalid_attrs %{code: nil, main_description: nil, name: nil, short_description: nil}

    def product_type_fixture(attrs \\ %{}) do
      {:ok, product_type} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_product_type()

      product_type
    end

    test "list_product_types/0 returns all product_types" do
      product_type = product_type_fixture()
      assert Products.list_product_types() == [product_type]
    end

    test "get_product_type!/1 returns the product_type with given id" do
      product_type = product_type_fixture()
      assert Products.get_product_type!(product_type.id) == product_type
    end

    test "create_product_type/1 with valid data creates a product_type" do
      assert {:ok, %ProductType{} = product_type} = Products.create_product_type(@valid_attrs)
      assert product_type.code == "some code"
      assert product_type.main_description == "some main_description"
      assert product_type.name == "some name"
      assert product_type.short_description == "some short_description"
    end

    test "create_product_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product_type(@invalid_attrs)
    end

    test "update_product_type/2 with valid data updates the product_type" do
      product_type = product_type_fixture()
      assert {:ok, product_type} = Products.update_product_type(product_type, @update_attrs)
      assert %ProductType{} = product_type
      assert product_type.code == "some updated code"
      assert product_type.main_description == "some updated main_description"
      assert product_type.name == "some updated name"
      assert product_type.short_description == "some updated short_description"
    end

    test "update_product_type/2 with invalid data returns error changeset" do
      product_type = product_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product_type(product_type, @invalid_attrs)
      assert product_type == Products.get_product_type!(product_type.id)
    end

    test "delete_product_type/1 deletes the product_type" do
      product_type = product_type_fixture()
      assert {:ok, %ProductType{}} = Products.delete_product_type(product_type)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product_type!(product_type.id) end
    end

    test "change_product_type/1 returns a product_type changeset" do
      product_type = product_type_fixture()
      assert %Ecto.Changeset{} = Products.change_product_type(product_type)
    end
  end
end
