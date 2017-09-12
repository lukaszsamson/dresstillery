defmodule Dresstillery.Dictionaries do
  @moduledoc """
  The Dictionaries context.
  """

  import Ecto.Query, warn: false
  alias Dresstillery.Repo

  alias Dresstillery.Dictionaries.Fabric

  @doc """
  Returns the list of fabrics.

  ## Examples

      iex> list_fabrics()
      [%Fabric{}, ...]

  """
  def list_fabrics do
    Repo.all(Fabric)
  end

  @doc """
  Gets a single fabric.

  Raises `Ecto.NoResultsError` if the Fabric does not exist.

  ## Examples

      iex> get_fabric!(123)
      %Fabric{}

      iex> get_fabric!(456)
      ** (Ecto.NoResultsError)

  """
  def get_fabric!(id), do: Repo.get!(Fabric, id)

  @doc """
  Creates a fabric.

  ## Examples

      iex> create_fabric(%{field: value})
      {:ok, %Fabric{}}

      iex> create_fabric(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_fabric(attrs \\ %{}) do
    %Fabric{}
    |> Fabric.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a fabric.

  ## Examples

      iex> update_fabric(fabric, %{field: new_value})
      {:ok, %Fabric{}}

      iex> update_fabric(fabric, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_fabric(%Fabric{} = fabric, attrs) do
    fabric
    |> Fabric.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Fabric.

  ## Examples

      iex> delete_fabric(fabric)
      {:ok, %Fabric{}}

      iex> delete_fabric(fabric)
      {:error, %Ecto.Changeset{}}

  """
  def delete_fabric(%Fabric{} = fabric) do
    Repo.delete(fabric)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking fabric changes.

  ## Examples

      iex> change_fabric(fabric)
      %Ecto.Changeset{source: %Fabric{}}

  """
  def change_fabric(%Fabric{} = fabric) do
    Fabric.changeset(fabric, %{})
  end

  alias Dresstillery.Dictionaries.FabricImage

  @doc """
  Returns the list of fabric_images.

  ## Examples

      iex> list_fabric_images()
      [%FabricImage{}, ...]

  """
  def list_fabric_images(fabric_id) do
    from(pi in FabricImage,
    where: pi.fabric_id == ^fabric_id,
    order_by: pi.order,
    preload: [:image])
    |> Repo.all
  end

  @doc """
  Gets a single fabric_image.

  Raises `Ecto.NoResultsError` if the Fabric image does not exist.

  ## Examples

      iex> get_fabric_image!(123)
      %FabricImage{}

      iex> get_fabric_image!(456)
      ** (Ecto.NoResultsError)

  """
  def get_fabric_image!(id), do: Repo.get!(FabricImage, id) |> Repo.preload(:image)

  @doc """
  Creates a fabric_image.

  ## Examples

      iex> create_fabric_image(%{field: value})
      {:ok, %FabricImage{}}

      iex> create_fabric_image(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_fabric_image(fabric_id, attrs \\ %{}) do
    fabric = get_fabric! fabric_id

    %FabricImage{}
    |> FabricImage.create_changeset(attrs)
    |> Ecto.Changeset.put_assoc(:fabric, fabric)
    |> Repo.insert()
  end

  @doc """
  Updates a fabric_image.

  ## Examples

      iex> update_fabric_image(fabric_image, %{field: new_value})
      {:ok, %FabricImage{}}

      iex> update_fabric_image(fabric_image, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_fabric_image(%FabricImage{} = fabric_image, attrs) do
    fabric_image
    |> FabricImage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a FabricImage.

  ## Examples

      iex> delete_fabric_image(fabric_image)
      {:ok, %FabricImage{}}

      iex> delete_fabric_image(fabric_image)
      {:error, %Ecto.Changeset{}}

  """
  def delete_fabric_image(%FabricImage{} = fabric_image) do
    Repo.delete(fabric_image)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking fabric_image changes.

  ## Examples

      iex> change_fabric_image(fabric_image)
      %Ecto.Changeset{source: %FabricImage{}}

  """
  def change_fabric_image(fabric_id, %FabricImage{} = fabric_image) do
    order = from(pi in FabricImage,
    where: pi.fabric_id == ^fabric_id,
    select: max(pi.order))
    |> Repo.one || -1
    FabricImage.changeset(fabric_image, %{order: order + 1})
  end
  def change_fabric_image(%FabricImage{} = fabric_image) do
    FabricImage.changeset(fabric_image, %{})
  end
end
