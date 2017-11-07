defmodule DresstilleryWeb.ErrorView do
  use DresstilleryWeb, :view

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Internal server error"
  end

  def render("503.html", _assigns) do
    "Service temporarily unavailable"
  end

  def render("401.json", _assigns) do
    %{error: "Unauthorized"}
  end

  def render("404.json", _assigns) do
    %{error: "Not found"}
  end

  def render("503.json", _assigns) do
    %{error: "Service temporarily unavailable"}
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    IO.inspect assigns
    render "500.html", assigns
  end
end
