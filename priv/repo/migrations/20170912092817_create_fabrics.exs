defmodule Dresstillery.Repo.Migrations.CreateFabrics do
  use Ecto.Migration

  def change do
    create table(:fabrics) do
      add :name, :string
      add :description, :string

      timestamps()
    end

  end
end
