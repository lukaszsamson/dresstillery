defmodule Dresstillery.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dresstillery.Products.Product


  schema "products" do
    field :price, :decimal
    field :lenght, :integer
    field :specific_description, :string

    has_many :images, Dresstillery.Products.ProductImage
    belongs_to :product_type, Dresstillery.Products.ProductType

    embeds_many :parts, Dresstillery.Products.Part, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(%Product{} = product, attrs) do
    product
    |> cast(attrs, [:price, :specific_description, :product_type_id, :lenght])
    |> validate_required([:price, :specific_description, :product_type_id, :lenght])
    |> cast_embed(:parts, attrs[:parts] || [])
  end

  
end

# podszewka:bawełna:25,wiskoza:75;wierzch:wełna:100
# wełna:100
#
# <dl>
# <dd>bawełna</dt><dt>25%</dt>
# </dl>
