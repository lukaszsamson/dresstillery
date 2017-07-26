defmodule DresstilleryWeb.AuthorizeTest do
  use DresstilleryWeb.ConnCase

  setup %{conn: conn} do
    conn = conn
    |> bypass_through(DresstilleryWeb.Router, :browser)
    |> get(page_path(conn, :index))
    {:ok, %{conn: conn}}
  end

  test "authorize halts and redirects if no permission", %{conn: conn} do
    conn = conn
    |> assign(:current_user_permissions, MapSet.new)
    |> DresstilleryWeb.Authorize.call(["test"] |> MapSet.new)

    assert conn.halted
    assert redirected_to(conn) == page_path(conn, :index)
    assert get_flash(conn, :error) == "Unauthorized"
  end

  test "authorize passes if permission", %{conn: conn} do
    conn = conn
    |> assign(:current_user_permissions, ["test"] |> MapSet.new)
    |> DresstilleryWeb.Authorize.call(["test"] |> MapSet.new)

    refute conn.halted
    refute get_flash(conn, :error)
  end
end
