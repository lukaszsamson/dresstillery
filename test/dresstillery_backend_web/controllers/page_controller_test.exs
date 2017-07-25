defmodule DresstilleryBackend.Web.PageControllerTest do
  use DresstilleryBackend.Web.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Dresstillery"
  end

  test "GET /admin", %{conn: conn} do
    conn = get conn, "/admin"
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
