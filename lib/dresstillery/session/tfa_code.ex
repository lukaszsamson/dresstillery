defmodule Dresstillery.Session.TfaCode do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dresstillery.Session.TfaCode

  embedded_schema do
    field :code, :string
  end

  def changeset(%TfaCode{} = struct, attrs) do
    struct
    |> cast(attrs, [:code])
    |> validate_required([:code])
    |> validate_format(:code, ~r/\d{6}/)
  end

  def add_code_error(struct) do
    struct
    |> add_error(:code, "invalid code")
  end
end
