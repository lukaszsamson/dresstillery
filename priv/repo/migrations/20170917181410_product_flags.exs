defmodule Dresstillery.Repo.Migrations.ProductFlags do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :available, :boolean, default: true, null: false
      add :hidden, :boolean, default: true, null: false
    end

    alter table(:fabrics) do
      add :code, :string, null: false, default: ""
      modify :description, :string, null: false, size: 2000
      add :available, :boolean, default: true, null: false
      add :hidden, :boolean, default: true, null: false
    end
  end
end
