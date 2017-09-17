defmodule Dresstillery.Repo.Migrations.ImageFileNameRequired do
    use Ecto.Migration
    alias Dresstillery.Repo
    alias Dresstillery.Media.Image

    def change do
      Repo.all(Image)
      |> Enum.map(fn i ->
        i
        |> Image.changeset(%{file_name: i.path |> Path.basename })
        |> Repo.update!
      end)

      alter table(:images) do
        modify :file_name, :string, null: true
      end
    end
  end
