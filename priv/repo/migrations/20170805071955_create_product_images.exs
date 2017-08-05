defmodule Dresstillery.Repo.Migrations.CreateProductImages do
  use Ecto.Migration

  def change do
    create table(:product_images) do
      add :order, :integer, null: false
      add :product_id, references(:products, on_delete: :delete_all), null: false
      add :image_id, references(:images, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:product_images, [:product_id])
    create index(:product_images, [:image_id])
    create unique_index(:product_images, [:product_id, :order])
    create unique_index(:product_images, [:product_id, :image_id])
  end
end
