defmodule DresstilleryWeb.AuthenticateTest do
  use DresstilleryWeb.ConnCase
  alias DresstilleryWeb.Router.Helpers, as: RouteHelpers
  alias Dresstillery.Administration.BackofficeUser
  alias Dresstillery.Administration.Permission
  alias Dresstillery.Repo

  setup %{conn: conn} do
    conn = conn
    |> bypass_through(DresstilleryWeb.Router, :browser)
    |> get(page_path(conn, :index))
    {:ok, %{conn: conn}}
  end

  test "authenticate passes if no session but not required", %{conn: conn} do
    conn = conn
    |> DresstilleryWeb.Authenticate.call([require_session: false])

    refute conn.halted
    refute conn.assigns[:current_user]
    refute conn.assigns[:current_user_permissions]
  end


  test "authenticate halts and redirects if no session", %{conn: conn} do
    conn = conn
    |> DresstilleryWeb.Authenticate.call([])

    assert conn.halted
    assert redirected_to(conn) == RouteHelpers.session_path(conn, :login_page)
  end

  test "authenticate halts and redirects if session but no user", %{conn: conn} do
    conn = conn
    |> put_session(:current_user, 333)
    |> DresstilleryWeb.Authenticate.call([])

    assert conn.halted
    assert redirected_to(conn) == RouteHelpers.session_path(conn, :login_page)
  end

  test "authenticate passes if user assigned", %{conn: conn} do
    conn = conn
    |> assign(:current_user, %BackofficeUser{})
    |> DresstilleryWeb.Authenticate.call([])

    refute conn.halted
  end

  test "authenticate passes if user exists and has permissions", %{conn: conn} do
    user = %BackofficeUser{id: 333, login: "asd@sad", password: "sdfdsfsd", permissions: [%Permission{name: "test"}]}
    |> Ecto.Changeset.change
    |> Repo.insert!

    conn = conn
    |> put_session(:current_user, 333)
    |> DresstilleryWeb.Authenticate.call([])

    refute conn.halted
    assert conn.assigns[:current_user].id == user.id
    assert conn.assigns[:current_user_permissions] == ["test"] |> MapSet.new
  end

  test "authenticate passes if user exists and has no permissions", %{conn: conn} do
    user = Repo.insert! %BackofficeUser{id: 333, login: "asd@sad", password: "sdfdsfsd"}
    conn = conn
    |> put_session(:current_user, 333)
    |> DresstilleryWeb.Authenticate.call([])

    refute conn.halted
    assert conn.assigns[:current_user].id == user.id
    assert conn.assigns[:current_user_permissions] == MapSet.new
  end

  test "authenticate halts and redirects if user not active", %{conn: conn} do
    _user = Repo.insert! %BackofficeUser{id: 333, login: "asd@sad", password: "sdfdsfsd", active: false}
    conn = conn
    |> put_session(:current_user, 333)
    |> DresstilleryWeb.Authenticate.call([])

    assert conn.halted
    assert redirected_to(conn) == RouteHelpers.session_path(conn, :login_page)
  end
end
