defmodule Dresstillery.Repo.Migrations.FacebookAuthentication do
  use Ecto.Migration

  def change do
    create table(:facebook_authentications, primary_key: false) do
      add :external_id, :string, null: false
      add :user_id, references(:users), primary_key: true

      timestamps()
    end

    create unique_index(:facebook_authentications, [:external_id])
  end
end
