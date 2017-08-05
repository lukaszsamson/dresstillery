defmodule Dresstillery.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dresstillery.Products.Product


  schema "products" do
    field :code, :string
    field :label, :string
    field :price, :decimal

    has_many :images, Dresstillery.Products.ProductImage

    timestamps()
  end

  @doc false
  def changeset(%Product{} = product, attrs) do
    product
    |> cast(attrs, [:code, :label, :price])
    |> validate_required([:code, :label, :price])
    |> unique_constraint(:code)
  end
end
