defmodule Dresstillery.Administration.FacebookAuthentication do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dresstillery.Administration.FacebookAuthentication

  @primary_key {:user_id, :id, autogenerate: false}
  schema "facebook_authentications" do
    field :external_id, :string
    belongs_to :user, Dresstillery.Administration.User, define_field: false
    timestamps()
  end

  @doc false
  def changeset(%FacebookAuthentication{} = user, attrs) do
    user
    |> cast(attrs, [:external_id])
    |> validate_required([:external_id])
  end
end
