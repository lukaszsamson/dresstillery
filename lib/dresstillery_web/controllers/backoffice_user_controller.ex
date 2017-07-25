defmodule DresstilleryWeb.BackofficeUserController do
  use DresstilleryWeb, :controller

  alias Dresstillery.Administration
  alias Dresstillery.Administration.BackofficeUser

  def index(conn, _params) do
    backoffice_users = Administration.list_backoffice_users()
    render(conn, "index.html", backoffice_users: backoffice_users)
  end

  def new(conn, _params) do
    changeset = Administration.change_backoffice_user(%BackofficeUser{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"backoffice_user" => backoffice_user_params}) do
    case Administration.create_backoffice_user(backoffice_user_params) do
      {:ok, backoffice_user} ->
        conn
        |> put_flash(:info, "Backoffice user created successfully.")
        |> redirect(to: backoffice_user_path(conn, :show, backoffice_user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    backoffice_user = Administration.get_backoffice_user!(id)
    render(conn, "show.html", backoffice_user: backoffice_user)
  end

  def edit(conn, %{"id" => id}) do
    backoffice_user = Administration.get_backoffice_user!(id)
    changeset = Administration.change_backoffice_user(backoffice_user)
    render(conn, "edit.html", backoffice_user: backoffice_user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "backoffice_user" => backoffice_user_params}) do
    backoffice_user = Administration.get_backoffice_user!(id)

    case Administration.update_backoffice_user(backoffice_user, backoffice_user_params) do
      {:ok, backoffice_user} ->
        conn
        |> put_flash(:info, "Backoffice user updated successfully.")
        |> redirect(to: backoffice_user_path(conn, :show, backoffice_user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", backoffice_user: backoffice_user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    backoffice_user = Administration.get_backoffice_user!(id)
    {:ok, _backoffice_user} = Administration.delete_backoffice_user(backoffice_user)

    conn
    |> put_flash(:info, "Backoffice user deleted successfully.")
    |> redirect(to: backoffice_user_path(conn, :index))
  end
end
