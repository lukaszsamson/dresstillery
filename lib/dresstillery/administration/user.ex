defmodule Dresstillery.Administration.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dresstillery.Administration.User


  schema "users" do
    timestamps()

    has_one :facebook_authentication, Dresstillery.Administration.FacebookAuthentication
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [])
    |> validate_required([])
  end
end
