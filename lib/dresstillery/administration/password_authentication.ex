defmodule Dresstillery.Administration.PasswordAuthentication do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dresstillery.Administration.PasswordAuthentication

  @primary_key {:user_id, :id, autogenerate: false}
  schema "password_authentications" do
    field :login, :string
    field :password, :string
    belongs_to :user, Dresstillery.Administration.User, define_field: false
    timestamps()
  end

  @doc false
  def changeset(%PasswordAuthentication{} = user, attrs) do
    user
    |> cast(attrs, [:login, :password])
    |> validate_required([:login, :password])
    |> validate_length(:login, max: 60)
    |> validate_length(:password, max: 60)
    |> hash_password
    |> unique_constraint(:login)
  end

  def hash_password(cs = %{valid?: false}), do: cs
  def hash_password(cs = %{valid?: true}) do
    pass = get_field cs, :password
    cs
    |> change(%{password: Comeonin.Bcrypt.hashpwsalt(pass)})
  end

  def check_password(nil, _) do
    Comeonin.Bcrypt.dummy_checkpw()
  end

  def check_password(user, password) do
    Comeonin.Bcrypt.checkpw(password, user.password_authentication.password)
  end
end
