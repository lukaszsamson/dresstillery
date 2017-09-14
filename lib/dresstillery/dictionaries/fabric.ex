defmodule Dresstillery.Dictionaries.Fabric do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dresstillery.Dictionaries.Fabric


  schema "fabrics" do
    field :description, :string
    field :name, :string

    embeds_many :ingridients, Dresstillery.Dictionaries.Ingridient, on_replace: :delete

    has_many :images, Dresstillery.Dictionaries.FabricImage

    timestamps()
  end

  @doc false
  def changeset(%Fabric{} = fabric, attrs) do
    fabric
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
    |> cast_embed(:ingridients, attrs[:ingridients] || [])
  end
end
