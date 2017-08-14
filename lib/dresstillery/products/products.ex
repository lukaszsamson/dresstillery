defmodule Dresstillery.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  alias Dresstillery.Repo

  alias Dresstillery.Products.Product

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    from(p in Product,
    preload: [images: [:image]]
    )
    |> Repo.all
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Repo.get!(Product, id) |> Repo.preload(images: [:image])

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{source: %Product{}}

  """
  def change_product(%Product{} = product) do
    Product.changeset(product, %{})
  end

  alias Dresstillery.Products.ProductImage

  @doc """
  Returns the list of product_images.

  ## Examples

      iex> list_product_images()
      [%ProductImage{}, ...]

  """
  def list_product_images(product_id) do
    from(pi in ProductImage,
    where: pi.product_id == ^product_id,
    order_by: pi.order,
    preload: [:image])
    |> Repo.all
  end

  @doc """
  Gets a single product_image.

  Raises `Ecto.NoResultsError` if the Product image does not exist.

  ## Examples

      iex> get_product_image!(123)
      %ProductImage{}

      iex> get_product_image!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product_image!(id), do: Repo.get!(ProductImage, id) |> Repo.preload(:image)

  @doc """
  Creates a product_image.

  ## Examples

      iex> create_product_image(%{field: value})
      {:ok, %ProductImage{}}

      iex> create_product_image(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product_image(product_id, attrs \\ %{}) do
    product = get_product! product_id

    %ProductImage{}
    |> ProductImage.create_changeset(attrs)
    |> Ecto.Changeset.put_assoc(:product, product)
    |> Repo.insert()
  end

  @doc """
  Updates a product_image.

  ## Examples

      iex> update_product_image(product_image, %{field: new_value})
      {:ok, %ProductImage{}}

      iex> update_product_image(product_image, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product_image(%ProductImage{} = product_image, attrs) do
    product_image
    |> ProductImage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ProductImage.

  ## Examples

      iex> delete_product_image(product_image)
      {:ok, %ProductImage{}}

      iex> delete_product_image(product_image)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product_image(%ProductImage{} = product_image) do
    Repo.delete(product_image)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product_image changes.

  ## Examples

      iex> change_product_image(product_image)
      %Ecto.Changeset{source: %ProductImage{}}

  """
  def change_product_image(product_id, %ProductImage{} = product_image) do
    order = from(pi in ProductImage,
    where: pi.product_id == ^product_id,
    select: max(pi.order))
    |> Repo.one || -1
    ProductImage.changeset(product_image, %{order: order + 1})
  end
  def change_product_image(%ProductImage{} = product_image) do
    ProductImage.changeset(product_image, %{})
  end

  alias Dresstillery.Products.ProductType

  @doc """
  Returns the list of product_types.

  ## Examples

      iex> list_product_types()
      [%ProductType{}, ...]

  """
  def list_product_types do
    Repo.all(ProductType)
  end

  @doc """
  Gets a single product_type.

  Raises `Ecto.NoResultsError` if the Product type does not exist.

  ## Examples

      iex> get_product_type!(123)
      %ProductType{}

      iex> get_product_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product_type!(id), do: Repo.get!(ProductType, id)

  @doc """
  Creates a product_type.

  ## Examples

      iex> create_product_type(%{field: value})
      {:ok, %ProductType{}}

      iex> create_product_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product_type(attrs \\ %{}) do
    %ProductType{}
    |> ProductType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product_type.

  ## Examples

      iex> update_product_type(product_type, %{field: new_value})
      {:ok, %ProductType{}}

      iex> update_product_type(product_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product_type(%ProductType{} = product_type, attrs) do
    product_type
    |> ProductType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ProductType.

  ## Examples

      iex> delete_product_type(product_type)
      {:ok, %ProductType{}}

      iex> delete_product_type(product_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product_type(%ProductType{} = product_type) do
    Repo.delete(product_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product_type changes.

  ## Examples

      iex> change_product_type(product_type)
      %Ecto.Changeset{source: %ProductType{}}

  """
  def change_product_type(%ProductType{} = product_type) do
    ProductType.changeset(product_type, %{})
  end
end
