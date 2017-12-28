defmodule Dresstillery.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset


  schema "orders" do
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:status])
    |> validate_required([:status])
  end
end
