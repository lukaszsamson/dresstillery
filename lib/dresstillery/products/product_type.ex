defmodule Dresstillery.Products.ProductType do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dresstillery.Products.ProductType


  schema "product_types" do
    field :code, :string
    field :main_description, :string
    field :name, :string
    field :short_description, :string

    timestamps()
  end

  @doc false
  def changeset(%ProductType{} = product_type, attrs) do
    product_type
    |> cast(attrs, [:name, :code, :short_description, :main_description])
    |> validate_required([:name, :code, :short_description, :main_description])
  end
end
