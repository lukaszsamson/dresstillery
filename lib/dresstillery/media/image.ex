defmodule Dresstillery.Media.Image do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dresstillery.Media.Image


  schema "images" do
    field :path, :string

    timestamps()
  end

  @doc false
  def changeset(%Image{} = image, attrs) do
    image
    |> cast(attrs, [:path])
    |> validate_required([:path])
  end
end
