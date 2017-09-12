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
end
