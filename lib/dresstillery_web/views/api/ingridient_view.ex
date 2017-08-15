defmodule DresstilleryWeb.Api.IngridientView do
  use DresstilleryWeb, :view

  def render("ingridient.json", %{ingridient: ingridient}) do
    %{name: ingridient.name,
      percentage: ingridient.percentage}
  end
end
