defmodule Dresstillery.Administration do
  @moduledoc """
  The Administration context.
  """

  import Ecto.Query, warn: false
  alias Dresstillery.Repo

  alias Dresstillery.Administration.BackofficeUser

  @doc """
  Returns the list of backoffice_users.

  ## Examples

      iex> list_backoffice_users()
      [%BackofficeUser{}, ...]

  """
  def list_backoffice_users do
    Repo.all(BackofficeUser)
  end

  @doc """
  Gets a single backoffice_user.

  Raises `Ecto.NoResultsError` if the Backoffice user does not exist.

  ## Examples

      iex> get_backoffice_user!(123)
      %BackofficeUser{}

      iex> get_backoffice_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_backoffice_user!(id), do: Repo.get!(BackofficeUser, id)

  @doc """
  Creates a backoffice_user.

  ## Examples

      iex> create_backoffice_user(%{field: value})
      {:ok, %BackofficeUser{}}

      iex> create_backoffice_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_backoffice_user(attrs \\ %{}) do
    %BackofficeUser{}
    |> BackofficeUser.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a backoffice_user.

  ## Examples

      iex> update_backoffice_user(backoffice_user, %{field: new_value})
      {:ok, %BackofficeUser{}}

      iex> update_backoffice_user(backoffice_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_backoffice_user(%BackofficeUser{} = backoffice_user, attrs) do
    backoffice_user
    |> BackofficeUser.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a BackofficeUser.

  ## Examples

      iex> delete_backoffice_user(backoffice_user)
      {:ok, %BackofficeUser{}}

      iex> delete_backoffice_user(backoffice_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_backoffice_user(%BackofficeUser{} = backoffice_user) do
    Repo.delete(backoffice_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking backoffice_user changes.

  ## Examples

      iex> change_backoffice_user(backoffice_user)
      %Ecto.Changeset{source: %BackofficeUser{}}

  """
  def change_backoffice_user(%BackofficeUser{} = backoffice_user) do
    BackofficeUser.changeset(backoffice_user, %{})
  end
end