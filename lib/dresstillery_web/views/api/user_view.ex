defmodule DresstilleryWeb.Api.UserView do
  use DresstilleryWeb, :view
  alias DresstilleryWeb.Api.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    token = Phoenix.Token.sign(DresstilleryWeb.Endpoint, "uhbcqdcwdncn76g2d7bd2wdbshab", user.id)
    %{id: user.id, token: token}
  end
end
