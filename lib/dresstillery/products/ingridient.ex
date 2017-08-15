defmodule Dresstillery.Products.Ingridient do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dresstillery.Products.Ingridient

  embedded_schema do
    field :name, :string
    field :percentage, :integer
  end


  def changeset(%Ingridient{} = reward, attrs) do
    reward
    |> cast(attrs, [:name, :percentage])
    |> validate_required([:name, :percentage])
  end
end

defmodule Dresstillery.Products.Part do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dresstillery.Products.Part

  embedded_schema do
    field :name, :string
    embeds_many :ingridients, Dresstillery.Products.Ingridient, on_replace: :delete
  end


  def changeset(%Part{} = reward, attrs) do
    reward
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> cast_embed(:ingridients, attrs[:ingridients] || [])
  end
end
