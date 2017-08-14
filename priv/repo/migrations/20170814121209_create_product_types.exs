defmodule Dresstillery.Repo.Migrations.CreateProductTypes do
  use Ecto.Migration

  def change do
    create table(:product_types) do
      add :name, :string
      add :code, :string
      add :short_description, :string
      add :main_description, :string

      timestamps()
    end

  end
end
