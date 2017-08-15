defmodule Dresstillery.Repo.Migrations.AddIngridients do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :parts, {:array, :map}, default: [], null: false
      add :lenght, :integer, null: false
    end
  end
end
