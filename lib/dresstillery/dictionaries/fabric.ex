defmodule Dresstillery.Dictionaries.Fabric do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dresstillery.Dictionaries.Fabric


  schema "fabrics" do
    field :description, :string
    field :name, :string
    field :code, :string
    field :available, :boolean
    field :hidden, :boolean

    embeds_many :ingridients, Dresstillery.Dictionaries.Ingridient, on_replace: :delete

    has_many :images, Dresstillery.Dictionaries.FabricImage

    timestamps()
  end

  @doc false
  def changeset(%Fabric{} = fabric, attrs) do
    fabric
    |> cast(attrs, [:name, :code, :description, :available, :hidden])
    |> validate_required([:name, :code, :description, :available, :hidden])
    |> cast_embed(:ingridients, attrs[:ingridients] || [])
  end
end
