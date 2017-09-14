defmodule Dresstillery.Repo.Migrations.DescriptionLenghts do
  use Ecto.Migration

  def change do
    alter table(:product_types) do
      modify :main_description, :string, null: false, size: 2000
    end

    alter table(:products) do
      modify :specific_description, :string, null: false, size: 2000
    end
  end
end
