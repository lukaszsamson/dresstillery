defmodule Dresstillery.Administration.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dresstillery.Administration.User


  schema "users" do

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [])
    |> validate_required([])
  end
end
