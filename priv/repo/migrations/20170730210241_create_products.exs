defmodule Dresstillery.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :code, :string
      add :label, :string
      add :price, :decimal

      timestamps()
    end

    create unique_index(:products, [:code])
  end
end
