defmodule Dresstillery.Administration.BackofficeUser do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dresstillery.Administration.BackofficeUser


  schema "backoffice_users" do
    field :login, :string
    field :password, :string
    field :tfa_code, :string

    timestamps()
  end

  @doc false
  def changeset(%BackofficeUser{} = backoffice_user, attrs) do
    backoffice_user
    |> cast(attrs, [:login, :password, :tfa_code])
    |> validate_required([:login, :password, :tfa_code])
  end
end
