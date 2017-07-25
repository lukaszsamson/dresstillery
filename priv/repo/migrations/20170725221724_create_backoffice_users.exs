defmodule DresstilleryBackend.Repo.Migrations.CreateBackofficeUsers do
  use Ecto.Migration

  def change do
    create table(:backoffice_users) do
      add :login, :string
      add :password, :string
      add :tfa_code, :string

      timestamps()
    end

  end
end
