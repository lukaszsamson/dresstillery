defmodule Dresstillery.Dictionaries.Ingridient do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dresstillery.Dictionaries.Ingridient

  embedded_schema do
    field :name, :string
    field :percentage, :integer
  end


  def changeset(%Ingridient{} = reward, attrs) do
    reward
    |> cast(attrs, [:name, :percentage])
    |> validate_required([:name, :percentage])
  end
end
