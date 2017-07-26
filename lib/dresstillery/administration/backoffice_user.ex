defmodule Dresstillery.Administration.BackofficeUser do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dresstillery.Administration.BackofficeUser

  @default_password "p@ssw0rd"

  schema "backoffice_users" do
    field :login, :string
    field :password, :string
    field :tfa_code, :string
    field :active, :boolean, default: true

    embeds_many :permissions, Dresstillery.Administration.Permission, on_replace: :delete

    timestamps()
  end

  def changeset(%BackofficeUser{} = backoffice_user, attrs) do
    backoffice_user
    |> cast(attrs, [:login])
    |> validate_required([:login])
    |> cast_embed(:permissions, attrs[:permissions] || [])
    |> change(%{password: Comeonin.Bcrypt.hashpwsalt(@default_password), tfa_code: nil})
    |> unique_constraint(:login)
  end

  def update_changeset(%BackofficeUser{} = backoffice_user, attrs) do
    backoffice_user
    |> cast(attrs, [:login])
    |> validate_required([:login])
    |> cast_embed(:permissions, attrs[:permissions] || [])
    |> unique_constraint(:login)
  end

  def change_password(%BackofficeUser{} = backoffice_user, attrs) do
    backoffice_user
    |> cast(attrs, [:password, :tfa_code])
    |> validate_required([:password, :tfa_code])
  end

  def reset_password(%BackofficeUser{} = backoffice_user) do
    backoffice_user
    |> change(%{password: Comeonin.Bcrypt.hashpwsalt(@default_password), tfa_code: nil})
  end

  def deactivate(%BackofficeUser{} = backoffice_user) do
    backoffice_user
    |> change(%{active: false})
  end
end
