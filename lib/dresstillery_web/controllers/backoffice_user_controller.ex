defmodule DresstilleryWeb.BackofficeUserController do
  use DresstilleryWeb, :controller

  alias Dresstillery.Administration
  alias Dresstillery.Administration.BackofficeUser
  alias Dresstillery.Administration.BackofficePermissions

  plug DresstilleryWeb.Authorize, require: ~w(manage_backoffice_users)

  def index(conn, _params) do
    backoffice_users = Administration.list_backoffice_users()
    render(conn, "index.html", backoffice_users: backoffice_users)
  end

  def new(conn, _params) do
    changeset = Administration.change_backoffice_user(%BackofficeUser{})
    render(conn, "new.html", changeset: changeset, permissions_values: permissions_values())
  end

  def create(conn, %{"backoffice_user" => backoffice_user_params}) do
    backoffice_user_params = backoffice_user_params
    |> Map.put("permissions", map_params_to_permissions(conn))
    case Administration.create_backoffice_user(backoffice_user_params) do
      {:ok, backoffice_user} ->
        conn
        |> put_flash(:info, "Backoffice user created successfully.")
        |> redirect(to: backoffice_user_path(conn, :show, backoffice_user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, permissions_values: permissions_values(conn))
    end
  end

  def show(conn, %{"id" => id}) do
    backoffice_user = Administration.get_backoffice_user!(id)
    render(conn, "show.html", backoffice_user: backoffice_user)
  end

  def edit(conn, %{"id" => id}) do
    backoffice_user = Administration.get_backoffice_user!(id)
    changeset = Administration.change_backoffice_user(backoffice_user)
    render(conn, "edit.html", backoffice_user: backoffice_user, changeset: changeset, permissions_values: permissions_values(backoffice_user))
  end

  def update(conn, %{"id" => id, "backoffice_user" => backoffice_user_params}) do
    backoffice_user = Administration.get_backoffice_user!(id)
    backoffice_user_params = backoffice_user_params
    |> Map.put("permissions", map_params_to_permissions(conn))

    case Administration.update_backoffice_user(backoffice_user, backoffice_user_params) do
      {:ok, backoffice_user} ->
        conn
        |> put_flash(:info, "Backoffice user updated successfully.")
        |> redirect(to: backoffice_user_path(conn, :show, backoffice_user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", backoffice_user: backoffice_user, changeset: changeset, permissions_values: permissions_values(conn))
    end
  end

  def reset_password(conn, %{"id" => id}) do
    backoffice_user = Administration.get_backoffice_user!(id)

    case Administration.reset_password(backoffice_user) do
      {:ok, _backoffice_user} ->
        conn
        |> put_flash(:info, "Password resetted successfully.")
        |> redirect(to: backoffice_user_path(conn, :index))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Password reset failed.")
        |> redirect(to: backoffice_user_path(conn, :index))
    end
  end

  def delete(conn, %{"id" => id}) do
    backoffice_user = Administration.get_backoffice_user!(id)
    {:ok, _backoffice_user} = Administration.deactivate(backoffice_user)

    conn
    |> put_flash(:info, "Backoffice user deleted successfully.")
    |> redirect(to: backoffice_user_path(conn, :show, backoffice_user))
  end

  defp map_params_to_permissions(conn) do
    case conn.params["permissions"] do
      nil -> []
      list ->
        list
        |> Enum.filter(& (&1 |> elem(1)) == "true")
        |> Enum.map(& %{name: &1 |> elem(0)})
    end
  end

  defp permissions_values do
    BackofficePermissions.all
    |> Enum.map(fn p ->
      {p, false}
    end)
    |> Enum.sort_by(&(elem(&1, 0)))
  end

  defp permissions_values(backoffice_user = %BackofficeUser{}) do
    BackofficePermissions.all
    |> Enum.map(fn p ->
      {p, backoffice_user.permissions |> Enum.any?(fn up -> up.name == p end)}
    end)
    |> Enum.sort_by(&(elem(&1, 0)))
  end

  defp permissions_values(conn) do
    case conn.params["permissions"] do
      nil -> permissions_values()
      list -> list
        |> Enum.map(fn {permission, value} ->
            {permission, (if value == "true", do: true, else: false)}
          end)
        |> Enum.sort_by(&(elem(&1, 0)))
    end
  end
end
