defmodule DresstilleryWeb.ImageView do
  use DresstilleryWeb, :view

  def image_src(image = %Dresstillery.Media.Image{}), do: "/media/#{Path.basename(image.path)}"
end
