defmodule Dresstillery.Media.Image do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dresstillery.Media.Image


  schema "images" do
    field :path, :string
    field :file_name, :string

    timestamps()
  end

  @doc false
  def changeset(%Image{} = image, attrs) do
    image
    |> cast(attrs, [:path, :file_name])
    |> validate_required([:path, :file_name])
  end
end
