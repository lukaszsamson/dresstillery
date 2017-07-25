defmodule Backoffice.AuthorizeTest do
  use Backoffice.ConnCase

  setup %{conn: conn} do
    conn = conn
    |> bypass_through(Backoffice.Router, :browser)
    |> get("/")
    {:ok, %{conn: conn}}
  end


  test "authorize halts and redirects if no permission", %{conn: conn} do
    conn = conn
    |> assign(:current_user_permissions, MapSet.new)
    |> Backoffice.Authorize.call(["test"] |> MapSet.new)

    assert conn.halted
    assert redirected_to(conn) == "/"
    assert get_flash(conn, :error) == "Unauthorized"
  end

  test "authorize passes if permission", %{conn: conn} do
    conn = conn
    |> assign(:current_user_permissions, ["test"] |> MapSet.new)
    |> Backoffice.Authorize.call(["test"] |> MapSet.new)

    refute conn.halted
    refute get_flash(conn, :error) == "Unauthorized"
  end
end
