defmodule Backoffice.AuthenticateTest do
  use Backoffice.ConnCase
  alias Common.BackofficeUser
  alias Common.Permission
  alias Backoffice.Router.Helpers, as: RouteHelpers

  setup %{conn: conn} do
    conn = conn
    |> bypass_through(Backoffice.Router, :browser)
    |> get("/")
    {:ok, %{conn: conn}}
  end


  test "authenticate halts and redirects if no session", %{conn: conn} do
    conn = conn
    |> Backoffice.Authenticate.call([])

    assert conn.halted
    assert redirected_to(conn) == RouteHelpers.session_path(conn, :login_page)
  end

  test "authenticate halts and redirects if session but no user", %{conn: conn} do
    conn = conn
    |> put_session(:current_user, 333)
    |> Backoffice.Authenticate.call([])

    assert conn.halted
    assert redirected_to(conn) == RouteHelpers.session_path(conn, :login_page)
  end

  test "authenticate passes if user assigned", %{conn: conn} do
    conn = conn
    |> assign(:current_user, %BackofficeUser{})
    |> Backoffice.Authenticate.call([])

    refute conn.halted
  end

  test "authenticate passes if user exists and has permissions", %{conn: conn} do
    permission = Repo.insert! %Permission{name: "test"}
    user = %BackofficeUser{id: 333, email: "asd@sad", password: "sdfdsfsd"}
    |> Ecto.Changeset.change
    |> Ecto.Changeset.put_assoc(:permissions, [permission])
    |> Repo.insert!

    conn = conn
    |> put_session(:current_user, 333)
    |> Backoffice.Authenticate.call([])

    refute conn.halted
    assert conn.assigns[:current_user].id == user.id
    assert conn.assigns[:current_user_permissions] == ["test"] |> MapSet.new
  end

  test "authenticate passes if user exists and has no permissions", %{conn: conn} do
    user = Repo.insert! %BackofficeUser{id: 333, email: "asd@sad", password: "sdfdsfsd"}
    conn = conn
    |> put_session(:current_user, 333)
    |> Backoffice.Authenticate.call([])

    refute conn.halted
    assert conn.assigns[:current_user].id == user.id
    assert conn.assigns[:current_user_permissions] == MapSet.new
  end

  test "authenticate halts and redirects if user not active", %{conn: conn} do
    _user = Repo.insert! %BackofficeUser{id: 333, email: "asd@sad", password: "sdfdsfsd", active: false}
    conn = conn
    |> put_session(:current_user, 333)
    |> Backoffice.Authenticate.call([])

    assert conn.halted
    assert redirected_to(conn) == RouteHelpers.session_path(conn, :login_page)
  end
end
