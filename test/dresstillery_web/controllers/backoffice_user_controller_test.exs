defmodule DresstilleryWeb.BackofficeUserControllerTest do
  use DresstilleryWeb.ConnCase

  alias Dresstillery.Administration
  alias Dresstillery.Administration.BackofficeUser
  alias Dresstillery.Repo

  @create_attrs %{login: "some login", password: "some password", tfa_code: "some tfa_code"}
  @update_attrs %{login: "some updated login", password: "some updated password", tfa_code: "some updated tfa_code"}
  @invalid_attrs %{login: nil, password: nil, tfa_code: nil}

  def fixture(:backoffice_user) do
    {:ok, backoffice_user} = Administration.create_backoffice_user(@create_attrs)
    backoffice_user
  end

  describe "index" do
    test "lists all backoffice_users", %{conn: conn} do
      conn = get conn, backoffice_user_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Backoffice users"
    end
  end

  describe "new backoffice_user" do
    test "renders form", %{conn: conn} do
      conn = get conn, backoffice_user_path(conn, :new)
      assert html_response(conn, 200) =~ "New Backoffice user"
    end
  end

  describe "create backoffice_user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, backoffice_user_path(conn, :create), backoffice_user: @create_attrs, permissions: [{"manage_users", "true"}]

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == backoffice_user_path(conn, :show, id)

      conn = get conn, backoffice_user_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Backoffice user"

      user = Repo.get(BackofficeUser, id)
      assert user.permissions |> Enum.find(& &1.name == "manage_users")
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, backoffice_user_path(conn, :create), backoffice_user: @invalid_attrs
      assert html_response(conn, 200) =~ "New Backoffice user"
    end
  end

  describe "edit backoffice_user" do
    setup [:create_backoffice_user]

    test "renders form for editing chosen backoffice_user", %{conn: conn, backoffice_user: backoffice_user} do
      conn = get conn, backoffice_user_path(conn, :edit, backoffice_user)
      assert html_response(conn, 200) =~ "Edit Backoffice user"
    end
  end

  describe "update backoffice_user" do
    setup [:create_backoffice_user]

    test "redirects when data is valid", %{conn: conn, backoffice_user: backoffice_user} do
      conn = put conn, backoffice_user_path(conn, :update, backoffice_user), backoffice_user: @update_attrs, permissions: [{"manage_users", "true"}, {"manage_backoffice_users", "true"}]
      assert redirected_to(conn) == backoffice_user_path(conn, :show, backoffice_user)

      conn = get conn, backoffice_user_path(conn, :show, backoffice_user)
      assert html_response(conn, 200) =~ "some updated login"

      user = Repo.get(BackofficeUser, backoffice_user.id)
      assert user
      assert user.permissions |> Enum.find(& &1.name == "manage_users")
      assert user.permissions |> Enum.find(& &1.name == "manage_backoffice_users")
      refute user.permissions |> Enum.find(& &1.name == "manage_orders")
    end

    test "renders errors when data is invalid", %{conn: conn, backoffice_user: backoffice_user} do
      conn = put conn, backoffice_user_path(conn, :update, backoffice_user), backoffice_user: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Backoffice user"
    end

    test "resets password and tfa secret", %{conn: conn} do
      backoffice_user = Repo.insert! %BackofficeUser{login: "some@content", password: Comeonin.Bcrypt.hashpwsalt("pass"), tfa_code: "6567276467245"}
      conn = post conn, backoffice_user_path(conn, :reset_password, backoffice_user)
      assert redirected_to(conn) == backoffice_user_path(conn, :index)
      assert get_flash(conn, :info) == "Password resetted successfully."
      user =  Repo.get(BackofficeUser, backoffice_user.id)
      refute user.tfa_code
      assert Comeonin.Bcrypt.checkpw("p@ssw0rd", user.password)
    end
  end

  describe "delete backoffice_user" do
    setup [:create_backoffice_user]

    test "deletes chosen backoffice_user", %{conn: conn, backoffice_user: backoffice_user} do
      conn = delete conn, backoffice_user_path(conn, :delete, backoffice_user)
      assert redirected_to(conn) == backoffice_user_path(conn, :show, backoffice_user)

      conn = get conn, backoffice_user_path(conn, :show, backoffice_user)
      assert html_response(conn, 200) =~ "false"
    end
  end

  defp create_backoffice_user(_) do
    backoffice_user = fixture(:backoffice_user)
    {:ok, backoffice_user: backoffice_user}
  end
end
