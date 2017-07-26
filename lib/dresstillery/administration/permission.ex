defmodule Dresstillery.Administration.Permission do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dresstillery.Administration.Permission

  embedded_schema do
    field :name, :string
  end


  def changeset(%Permission{} = reward, attrs) do
    reward
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_inclusion(:name, Dresstillery.Administration.BackofficePermissions.all)
  end
end
