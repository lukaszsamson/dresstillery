defmodule Dresstillery.Dictionaries.Fabric do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dresstillery.Dictionaries.Fabric


  schema "fabrics" do
    field :description, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Fabric{} = fabric, attrs) do
    fabric
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
