defmodule DresstilleryWeb.SessionController do
  use DresstilleryWeb, :controller
  alias Dresstillery.Session
  alias Dresstillery.Administration.BackofficeUser

  def login_page(conn, _params) do
    cond do
      get_session(conn, :tfa_user) -> redirect(conn, to: Routes.session_path(conn, :tfa_page))
      get_session(conn, :current_user) -> redirect(conn, to: Routes.page_path(conn, :index))
      true ->
        changeset = Session.login_changeset
        render(conn, "login_page.html", changeset: changeset)
    end
  end

  def login(conn, %{"user_login" => user_login_params}) do
    cond do
      get_session(conn, :tfa_user) -> redirect(conn, to: Routes.session_path(conn, :tfa_page))
      get_session(conn, :current_user) -> redirect(conn, to: Routes.page_path(conn, :index))
      true ->
        case Session.login(user_login_params) do
          {:ok, %BackofficeUser{tfa_code: nil} = user} ->
            conn
            |> configure_session(renew: true)
            |> put_session(:current_user, user.id)
            |> put_flash(:info, "Password change required")
            |> redirect(to: Routes.session_path(conn, :change_password_page))
          {:ok, user} ->
            conn
            |> configure_session(renew: true)
            |> put_session(:tfa_user, user.id)
            |> redirect(to: Routes.session_path(conn, :tfa_page))
          {:error, changeset} ->
            conn
            |> render("login_page.html", changeset: changeset)
        end
    end
  end

  def tfa_page(conn, _params) do
    cond do
      get_session(conn, :tfa_user) ->
        changeset = Session.tfa_changeset
        render(conn, "tfa_page.html", changeset: changeset)
      get_session(conn, :current_user) -> redirect(conn, to: Routes.page_path(conn, :index))
      true -> redirect(conn, to: Routes.session_path(conn, :login_page))
    end
  end

  def tfa(conn, %{"tfa_code" => tfa_code_params}) do
    cond do
      get_session(conn, :tfa_user) ->
        user = Dresstillery.Administration.get_active_backoffice_user get_session(conn, :tfa_user)

        case Session.tfa(user, tfa_code_params) do
          {:ok, user} ->
            conn
            |> put_session(:current_user, user.id)
            |> delete_session(:tfa_user)
            |> put_flash(:info, "Logged in")
            |> redirect(to: Routes.page_path(conn, :index))
          {:error, changeset} ->
            conn
            |> render("tfa_page.html", changeset: changeset)
        end
      get_session(conn, :current_user) -> redirect(conn, to: Routes.page_path(conn, :index))
      true -> redirect(conn, to: Routes.session_path(conn, :login_page))
    end
  end

  def change_password_page(conn, _params) do
    changeset = Session.change_password_changeset
    render(conn, "change_password_page.html", changeset: changeset, login: conn.assigns[:current_user].login, tfa_required: tfa_required?(conn))
  end

  def change_password(conn, %{"change_password" => change_password_params}) do
    case Session.change_password(conn.assigns[:current_user], change_password_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Password changed")
        |> redirect(to: Routes.page_path(conn, :index))
      {:error, changeset} ->
        conn
        |> render("change_password_page.html", changeset: changeset, login: conn.assigns[:current_user].login, tfa_required: tfa_required?(conn))
    end
  end

  defp tfa_required?(conn) do
    conn.assigns[:current_user].tfa_code != nil
  end

  def logout(conn, _) do
    conn
    |> clear_session
    |> configure_session(drop: true)
    |> halt
    |> redirect(to: Routes.session_path(conn, :login_page))
  end
end
