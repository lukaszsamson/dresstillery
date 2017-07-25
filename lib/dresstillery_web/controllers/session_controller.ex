defmodule Backoffice.SessionController do
  use Backoffice.Web, :controller
  alias Backoffice.UserLogin
  alias Backoffice.TfaCode
  alias Backoffice.ChangePassword

  def login_page(conn, _params) do
    cond do
      get_session(conn, :tfa_user) -> redirect(conn, to: session_path(conn, :tfa_page))
      get_session(conn, :current_user) -> redirect(conn, to: "/")
      true ->
        changeset = UserLogin.changeset(%UserLogin{})
        render(conn, "login_page.html", changeset: changeset)
    end
  end

  def login(conn, %{"user_login" => user_login_params}) do
    cond do
      get_session(conn, :tfa_user) -> redirect(conn, to: session_path(conn, :tfa_page))
      get_session(conn, :current_user) -> redirect(conn, to: "/")
      true ->
        changeset = UserLogin.changeset(%UserLogin{}, user_login_params)
        case Session.login(changeset) do
          {:ok, %Common.BackofficeUser{tfa_secret: nil} = user} ->
            conn
            |> configure_session(renew: true)
            |> put_session(:current_user, user.id)
            |> put_flash(:info, "Password change required")
            |> redirect(to: session_path(conn, :change_password_page))
          {:ok, user} ->
            conn
            |> configure_session(renew: true)
            |> put_session(:tfa_user, user.id)
            |> redirect(to: session_path(conn, :tfa_page))
          {:error, changeset} ->
            conn
            |> render("login_page.html", changeset: changeset)
        end
    end
  end

  def tfa_page(conn, _params) do
    cond do
      get_session(conn, :tfa_user) ->
        changeset = TfaCode.changeset(%TfaCode{})
        render(conn, "tfa_page.html", changeset: changeset)
      get_session(conn, :current_user) -> redirect(conn, to: "/")
      true -> redirect(conn, to: session_path(conn, :login_page))
    end
  end

  def tfa(conn, %{"tfa_code" => tfa_code_params}) do
    cond do
      get_session(conn, :tfa_user) ->
        user = Repo.get_by(Common.BackofficeUser, id: get_session(conn, :tfa_user), active: true)
        changeset = TfaCode.changeset(%TfaCode{}, tfa_code_params)
        case Session.tfa(changeset, user) do
          {:ok, user} ->
            conn
            |> put_session(:current_user, user.id)
            |> delete_session(:tfa_user)
            |> put_flash(:info, "Logged in")
            |> redirect(to: "/")
          {:error, changeset} ->
            conn
            |> render("tfa_page.html", changeset: changeset)
        end
      get_session(conn, :current_user) -> redirect(conn, to: "/")
      true -> redirect(conn, to: session_path(conn, :login_page))
    end
  end

  def change_password_page(conn, _params) do
    tfa_required = if conn.assigns[:current_user].tfa_secret != nil, do: true, else: false
    changeset = ChangePassword.changeset(%ChangePassword{tfa_secret: :crypto.strong_rand_bytes(10) |> Base.encode32})
    render(conn, "change_password_page.html", changeset: changeset, email: conn.assigns[:current_user].email, tfa_required: tfa_required)
  end

  def change_password(conn, %{"change_password" => change_password_params}) do
    tfa_required = if conn.assigns[:current_user].tfa_secret != nil, do: true, else: false
    changeset = if tfa_required do
      ChangePassword.changeset(%ChangePassword{}, change_password_params)
    else
      ChangePassword.changeset_no_secret(%ChangePassword{}, change_password_params)
    end
    case Session.change_password(changeset, conn.assigns[:current_user]) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Password changed")
        |> redirect(to: "/")
      {:error, changeset} ->
        conn
        |> render("change_password_page.html", changeset: changeset, email: conn.assigns[:current_user].email, tfa_required: tfa_required)
    end
  end

  def tfa_secret(conn, _params) do
    render(conn, "tfa_secret.html", user: "admin@alea.com", secret: "MFRGGZDFMZTWQ2LK")
  end

  def logout(conn, _) do
    conn
    |> clear_session
    |> configure_session(drop: true)
    |> halt
    |> redirect(to: session_path(conn, :login_page))
  end
end
