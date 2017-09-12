defmodule Dresstillery.Dictionaries.FabricImage do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dresstillery.Dictionaries.FabricImage


  schema "fabric_images" do
    field :order, :integer
    belongs_to :image, Dresstillery.Media.Image
    belongs_to :fabric, Dresstillery.Dictionaries.Fabric

    timestamps()
  end

  @doc false
  def changeset(%FabricImage{} = product_image, attrs) do
    product_image
    |> cast(attrs, [:order])
    |> validate_required([:order])
    |> unique_constraint(:order, name: :fabric_images_fabric_id_order_index)
  end

  def create_changeset(%FabricImage{} = product_image, attrs) do
    product_image
    |> cast(attrs, [:order, :image_id])
    |> validate_required([:order, :image_id])
    |> unique_constraint(:order, name: :fabric_images_fabric_id_order_index)
    |> unique_constraint(:image_id, name: :fabric_images_fabric_id_image_id_index)
  end
end
