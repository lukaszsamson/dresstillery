defmodule Dresstillery.Repo.Migrations.PasswordAuthentication do
  use Ecto.Migration

  def change do
    create table(:password_authentications, primary_key: false) do
      add :login, :string, null: false, size: 60
      add :password, :string, null: false, size: 60
      add :user_id, references(:users), primary_key: true

      timestamps()
    end

    create unique_index(:password_authentications, [:login])
  end
end
