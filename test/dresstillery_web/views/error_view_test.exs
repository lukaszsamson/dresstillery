defmodule DresstilleryWeb.ErrorViewTest do
  use DresstilleryWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(DresstilleryWeb.ErrorView, "404.html", []) ==
           "Page not found"
  end

  test "render 503.html" do
    assert render_to_string(DresstilleryWeb.ErrorView, "503.html", []) ==
           "Service temporarily unavailable"
  end

  test "render 500.html" do
    assert render_to_string(DresstilleryWeb.ErrorView, "500.html", []) ==
           "Internal server error"
  end

  test "renders 404.json" do
    assert render(DresstilleryWeb.ErrorView, "404.json", []) ==
           %{error: "Not found"}
  end

  test "renders 503.json" do
    assert render(DresstilleryWeb.ErrorView, "503.json", []) ==
           %{error: "Service temporarily unavailable"}
  end

  test "render any other" do
    assert render_to_string(DresstilleryWeb.ErrorView, "505.html", []) ==
           "Internal server error"
  end
end
