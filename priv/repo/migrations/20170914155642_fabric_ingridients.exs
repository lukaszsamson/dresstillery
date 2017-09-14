defmodule Dresstillery.Repo.Migrations.FabricIngridients do
  use Ecto.Migration

  def change do
    alter table(:fabrics) do
      add :ingridients, {:array, :map}, default: [], null: false
    end
  end
end
