defmodule Dresstillery.Products.ProductImage do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dresstillery.Products.ProductImage


  schema "product_images" do
    field :order, :integer
    belongs_to :image, Dresstillery.Media.Image
    belongs_to :product, Dresstillery.Products.Product

    timestamps()
  end

  @doc false
  def changeset(%ProductImage{} = product_image, attrs) do
    product_image
    |> cast(attrs, [:order])
    |> validate_required([:order])
    |> unique_constraint(:order, name: :product_images_product_id_order_index)
  end

  def create_changeset(%ProductImage{} = product_image, attrs) do
    product_image
    |> cast(attrs, [:order, :image_id])
    |> validate_required([:order, :image_id])
    |> unique_constraint(:order, name: :product_images_product_id_order_index)
    |> unique_constraint(:image_id, name: :product_images_product_id_image_id_index)
  end
end
