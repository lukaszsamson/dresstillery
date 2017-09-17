defmodule Dresstillery.Repo.Migrations.ImageFileName do
  use Ecto.Migration

  def change do
    alter table(:images) do
      add :file_name, :string, null: true
    end
  end
end
