defmodule Dresstillery.ProductsTest do
  use Dresstillery.DataCase

  alias Dresstillery.Products

  describe "products" do
    alias Dresstillery.Products.Product

    @valid_attrs %{code: "some code", label: "some label", price: "120.5"}
    @update_attrs %{code: "some updated code", label: "some updated label", price: "456.7"}
    @invalid_attrs %{code: nil, label: nil, price: nil}

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_product()

      product
      |> Repo.preload([images: :image])
    end

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Products.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Products.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = Products.create_product(@valid_attrs)
      assert product.code == "some code"
      assert product.label == "some label"
      assert product.price == Decimal.new("120.5")
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, product} = Products.update_product(product, @update_attrs)
      assert %Product{} = product
      assert product.code == "some updated code"
      assert product.label == "some updated label"
      assert product.price == Decimal.new("456.7")
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
      assert product == Products.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
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
      {:ok, product} = Products.create_product(%{code: "some code", label: "some label", price: "120.5"})
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
end
