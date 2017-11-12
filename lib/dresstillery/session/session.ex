defmodule Dresstillery.Session do
  alias Dresstillery.Session.UserLogin
  alias Dresstillery.Session.TfaCode
  alias Dresstillery.Session.ChangePassword
  alias Dresstillery.Administration.BackofficeUser
  alias Dresstillery.Administration
  import Ecto.Changeset
  import Comeonin.Bcrypt
  alias Dresstillery.Repo

  def login(attrs \\ %{}) do
    changeset = UserLogin.changeset(%UserLogin{}, attrs)
    changeset = %{changeset | action: :insert}

    if changeset.valid? do
      user = Repo.get_by(BackofficeUser, login: get_field(changeset, :login))

      if check_password(user, get_field(changeset, :password)) do
        if user.active do
          {:ok, user}
        else
          {:error, changeset |> UserLogin.add_not_active_error()}
        end
      else
        {:error, changeset |> UserLogin.add_password_error()}
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

  def tfa(user, tfa_code_params) do
    changeset = TfaCode.changeset(%TfaCode{}, tfa_code_params)
    changeset = %{changeset | action: :insert}

    if changeset.valid? do
      code = get_field(changeset, :code)

      if :pot.valid_totp(code, user.tfa_code) do
        {:ok, user}
      else
        {:error, changeset |> TfaCode.add_code_error()}
      end
    else
      {:error, changeset}
    end
  end

  def change_password(user, change_password_params) do
    changeset =
      if user.tfa_code != nil do
        ChangePassword.changeset(%ChangePassword{}, change_password_params)
      else
        ChangePassword.changeset_no_secret(%ChangePassword{}, change_password_params)
      end

    changeset = %{changeset | action: :insert}

    if changeset.valid? do
      if check_password(user, get_field(changeset, :password)) do
        code = get_field(changeset, :code)

        if user.tfa_code == nil or :pot.valid_totp(code, user.tfa_code) do
          Administration.change_password(user, %{
            password: hashpwsalt(get_field(changeset, :new_password)),
            tfa_code: get_field(changeset, :tfa_code)
          })
        else
          {:error, changeset |> ChangePassword.add_code_error()}
        end
      else
        {:error, changeset |> ChangePassword.add_password_error()}
      end
    else
      {:error, changeset}
    end
  end

  def change_password_changeset do
    ChangePassword.changeset(
      %ChangePassword{tfa_code: :crypto.strong_rand_bytes(10) |> Base.encode32()},
      %{}
    )
  end

  def tfa_changeset do
    TfaCode.changeset(%TfaCode{}, %{})
  end

  def login_changeset do
    UserLogin.changeset(%UserLogin{}, %{})
  end
end
