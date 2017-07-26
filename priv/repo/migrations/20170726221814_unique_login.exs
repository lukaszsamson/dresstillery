defmodule Dresstillery.Repo.Migrations.UniqueLogin do
  use Ecto.Migration

  def change do
    create unique_index(:backoffice_users, [:login])
  end
end
