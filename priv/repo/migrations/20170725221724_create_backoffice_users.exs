defmodule Dresstillery.Repo.Migrations.CreateBackofficeUsers do
  use Ecto.Migration

  def change do
    create table(:backoffice_users) do
      add :login, :string
      add :password, :string
      add :tfa_code, :string
      add :active, :boolean
      add :permissions, {:array, :map}

      timestamps()
    end

  end
end
