defmodule DresstilleryBackend.Web.Session do
  alias Backoffice.UserLogin
  alias Backoffice.TfaCode
  alias Backoffice.ChangePassword
  import Ecto.Changeset
  import Comeonin.Bcrypt
  alias DresstilleryBackend.Repo

  def login(changeset) do
    changeset = %{changeset | action: :insert}
    if changeset.valid? do
      user = Repo.get_by(Common.BackofficeUser, email: get_field(changeset, :email))
      if check_password(user, get_field(changeset, :password)) do
        if user.active do
          {:ok, user}
        else
          {:error, changeset |> UserLogin.add_not_active_error}
        end
      else
        {:error, changeset |> UserLogin.add_password_error}
      end
    else
      {:error, changeset}
    end
  end

  defp check_password(nil, _) do
    dummy_checkpw()
  end

  defp check_password(user, password) do
    checkpw(password, user.password)
  end

  def tfa(changeset, user) do
    changeset = %{changeset | action: :insert}
    if changeset.valid? do
      code = get_field(changeset, :code)
      if :pot.valid_totp(code, user.tfa_secret) do
        {:ok, user}
      else
        {:error, changeset |> TfaCode.add_code_error}
      end
    else
      {:error, changeset}
    end
  end

  def change_password(changeset, user) do
    changeset = %{changeset | action: :insert}
    if changeset.valid? do
      if check_password(user, get_field(changeset, :password)) do
        code = get_field(changeset, :code)
        if user.tfa_secret == nil or :pot.valid_totp(code, user.tfa_secret) do
          updated = Repo.update!(Common.BackofficeUser.changeset_password_change(user, %{password: hashpwsalt(get_field(changeset, :new_password)),
            tfa_secret: get_field(changeset, :tfa_secret)}))
          {:ok, updated}
        else
          {:error, changeset |> ChangePassword.add_code_error}
        end
      else
        {:error, changeset |> ChangePassword.add_password_error}
      end
    else
      {:error, changeset}
    end
  end
end
