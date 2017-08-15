defmodule Dresstillery.Repo.Migrations.CreateProductTypes do
  use Ecto.Migration

  def change do
    create table(:product_types) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :short_description, :string, null: false
      add :main_description, :string, null: false

      timestamps()
    end

    create unique_index(:product_types, [:code])
    drop unique_index(:products, [:code])

    alter table(:products) do
      remove :code
      remove :label
      add :product_type_id, references(:product_types, on_delete: :delete_all), null: false
      add :specific_description, :string, null: false
    end

    create index(:products, [:product_type_id])

  end
end
