defmodule Dresstillery.Session.UserLogin do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dresstillery.Session.UserLogin

  embedded_schema do
    field :login, :string
    field :password, :string
  end

  def changeset(%UserLogin{} = struct, attrs) do
    struct
    |> cast(attrs, [:login, :password])
    |> validate_required([:login, :password])
  end

  def add_password_error(struct) do
    struct
    |> add_error(:password, "invalid login or password")
  end

  def add_not_active_error(struct) do
    struct
    |> add_error(:login, "account deactivated")
  end
end
