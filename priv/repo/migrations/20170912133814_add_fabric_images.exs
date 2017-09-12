defmodule Dresstillery.Repo.Migrations.AddFabricImages do
  use Ecto.Migration

  def change do
    create table(:fabric_images) do
      add :order, :integer, null: false
      add :fabric_id, references(:fabrics, on_delete: :delete_all), null: false
      add :image_id, references(:images, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:fabric_images, [:fabric_id])
    create index(:fabric_images, [:image_id])
    create unique_index(:fabric_images, [:fabric_id, :order])
    create unique_index(:fabric_images, [:fabric_id, :image_id])
  end
end
