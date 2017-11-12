defmodule Dresstillery.Session.ChangePassword do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dresstillery.Session.ChangePassword
  import DresstilleryWeb.Gettext

  embedded_schema do
    field(:tfa_code, :string)
    field(:password, :string)
    field(:new_password, :string)
    field(:code, :string)
  end

  def changeset_no_secret(%ChangePassword{} = struct, attrs) do
    struct
    |> cast(attrs, [:password, :new_password, :tfa_code])
    |> validate_required([:password, :new_password, :tfa_code])
    |> validate_length(:new_password, min: 6)
    |> validate_confirmation(:new_password, required: true)
  end

  def changeset(%ChangePassword{} = struct, attrs) do
    struct
    |> cast(attrs, [:password, :new_password, :tfa_code, :code])
    |> validate_required([:password, :new_password, :tfa_code, :code])
    |> validate_length(:new_password, min: 6)
    |> validate_confirmation(:new_password, required: true)
  end

  def add_password_error(struct) do
    struct
    |> add_error(:password, dgettext("errors", "invalid password"))
  end

  def add_code_error(struct) do
    struct
    |> add_error(:code, dgettext("errors", "invalid code"))
  end
end
