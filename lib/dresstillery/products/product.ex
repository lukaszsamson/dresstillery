defmodule Dresstillery.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dresstillery.Products.Product


  schema "products" do
    field :price, :decimal
    field :specific_description, :string

    has_many :images, Dresstillery.Products.ProductImage
    belongs_to :product_type, Dresstillery.Products.ProductType

    timestamps()
  end

  @doc false
  def changeset(%Product{} = product, attrs) do
    product
    |> cast(attrs, [:price, :specific_description, :product_type_id])
    |> validate_required([:price, :specific_description, :product_type_id])

  end
end
