defmodule DresstilleryWeb.PageControllerTest do
  use DresstilleryWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Dresstillery"
  end

  test "GET /client_route", %{conn: conn} do
    conn = get conn, "/client_route"
    assert html_response(conn, 200) =~ "Dresstillery"
  end

  test "GET /non_existing.jpg", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, "/non_existing.jpg"
    end
  end

  test "GET /js/app.js", %{conn: conn} do
    conn = get conn, "/js/app.js"
    assert response(conn, 200) =~ "hasOwnProperty"
  end

  test "GET /admin", %{conn: conn} do
    conn = get conn, page_path(conn, :index)
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end

  test "GET /admin/non_existing", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, page_path(conn, :index) <> "/non_existing"
    end
  end
end
