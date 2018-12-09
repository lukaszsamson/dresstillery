defmodule DresstilleryWeb.ErrorView do
  use DresstilleryWeb, :view

  def render("400.html", _assigns) do
    "Bad request"
  end

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Internal server error"
  end

  def render("503.html", _assigns) do
    "Service temporarily unavailable"
  end

  def render("400.json", _assigns) do
    %{errors: "Bad request"}
  end

  def render("401.json", _assigns) do
    %{errors: "Unauthorized"}
  end

  def render("404.json", _assigns) do
    %{errors: "Not found"}
  end

  def render("token_not_valid.json", _assigns) do
    %{errors: %{_: ["Please login to Facebook again"]}}
  end

  def render("500.json", _assigns) do
    %{errors: "Internal server error"}
  end

  def render("503.json", _assigns) do
    %{errors: "Service temporarily unavailable"}
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
