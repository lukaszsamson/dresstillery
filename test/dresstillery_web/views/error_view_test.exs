defmodule DresstilleryWeb.ErrorViewTest do
  use DresstilleryWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "render 400.html" do
    assert render_to_string(DresstilleryWeb.ErrorView, "400.html", []) ==
           "Bad request"
  end

  test "renders 404.html" do
    assert render_to_string(DresstilleryWeb.ErrorView, "404.html", []) ==
           "Page not found"
  end

  test "render 500.html" do
    assert render_to_string(DresstilleryWeb.ErrorView, "500.html", []) ==
           "Internal server error"
  end

  test "render 503.html" do
    assert render_to_string(DresstilleryWeb.ErrorView, "503.html", []) ==
           "Service temporarily unavailable"
  end

  test "renders 400.json" do
    assert render(DresstilleryWeb.ErrorView, "400.json", []) ==
           %{errors: "Bad request"}
  end

  test "renders 401.json" do
    assert render(DresstilleryWeb.ErrorView, "401.json", []) ==
           %{errors: "Unauthorized"}
  end

  test "renders 404.json" do
    assert render(DresstilleryWeb.ErrorView, "404.json", []) ==
           %{errors: "Not found"}
  end

  test "renders 500.json" do
    assert render(DresstilleryWeb.ErrorView, "500.json", []) ==
           %{errors: "Internal server error"}
  end

  test "renders 503.json" do
    assert render(DresstilleryWeb.ErrorView, "503.json", []) ==
           %{errors: "Service temporarily unavailable"}
  end

  test "render any other" do
    assert render_to_string(DresstilleryWeb.ErrorView, "500.html", []) ==
           "Internal server error"
  end
end
