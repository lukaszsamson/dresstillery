defmodule Dresstillery.Administration do
  @moduledoc """
  The Administration context.
  """

  import Ecto.Query, warn: false
  alias Dresstillery.Repo

  alias Dresstillery.Administration.BackofficeUser
  alias Dresstillery.Administration.{User, FacebookAuthentication, PasswordAuthentication}
  @facebook_api Application.get_env(:dresstillery, :facebook_api, Dresstillery.FacebookApi)

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

  def get_active_backoffice_user(id), do: Repo.get_by(BackofficeUser, id: (id || -1), active: true)

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

  def update_backoffice_user(%BackofficeUser{} = backoffice_user, attrs) do
    backoffice_user
    |> BackofficeUser.update_changeset(attrs)
    |> Repo.update()
  end

  def change_password(%BackofficeUser{} = backoffice_user, attrs) do
    backoffice_user
    |> BackofficeUser.change_password(attrs)
    |> Repo.update()
  end

  def reset_password(%BackofficeUser{} = backoffice_user) do
    backoffice_user
    |> BackofficeUser.reset_password()
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
  def deactivate(%BackofficeUser{} = backoffice_user) do
    backoffice_user
    |> BackofficeUser.deactivate()
    |> Repo.update()
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

  alias Dresstillery.Administration.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def login_facebook(attrs \\ %{}) do
    case @facebook_api.is_valid(attrs[:token]) do
      false -> {:error, :token_not_valid}
      :error -> {:error, :facebook_api_error}
      {true, fb_id} ->
        get_or_create_facebook_user(fb_id)
    end
  end

  defp get_or_create_facebook_user(fb_id) do
    user = (from u in User,
    join: fb in assoc(u, :facebook_authentication),
    where: fb.external_id == ^fb_id,
    preload: [:facebook_authentication])
    |> Repo.one
    case user do
      nil ->
      fb = %FacebookAuthentication{}
      |> FacebookAuthentication.changeset(%{external_id: fb_id})
      %User{}
      |> User.changeset(%{})
      |> Ecto.Changeset.put_assoc(:facebook_authentication, fb)
      |> Repo.insert()
      user -> {:ok, user}
    end
  end

  def register(attrs \\ %{}) do
    pass = %PasswordAuthentication{}
    |> PasswordAuthentication.changeset(attrs)
    %User{}
    |> User.changeset(%{})
    |> Ecto.Changeset.put_assoc(:password_authentication, pass)
    |> Repo.insert()
  end

  def login(attrs \\ %{}) do
    user = (from u in User,
    join: fb in assoc(u, :password_authentication),
    where: fb.login == ^attrs[:login],
    preload: [:password_authentication])
    |> Repo.one
    if PasswordAuthentication.check_password(user, attrs[:password]) do
      {:ok, user}
    else
      {:error, :invalid_login_or_password}
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
