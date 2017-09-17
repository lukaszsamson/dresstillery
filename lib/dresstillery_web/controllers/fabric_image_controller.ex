defmodule DresstilleryWeb.FabricImageController do
  use DresstilleryWeb, :controller

  alias Dresstillery.Dictionaries
  alias Dresstillery.Media
  alias Dresstillery.Dictionaries.FabricImage

  defp get_images(fabric_id) do
    fabric_images = Dictionaries.list_fabric_images(fabric_id)
    |> Enum.map(& &1.image_id)

    Media.list_images()
    |> Enum.filter(& not(&1.id in fabric_images))
    |> Enum.map(& {&1.file_name, &1.id})
  end

  def index(conn, %{"fabric_id" => fabric_id}) do
    fabric_images = Dictionaries.list_fabric_images(fabric_id)
    render(conn, "index.html", fabric_id: fabric_id, fabric_images: fabric_images)
  end

  def new(conn, %{"fabric_id" => fabric_id}) do
    changeset = Dictionaries.change_fabric_image(fabric_id, %FabricImage{})
    render(conn, "new.html", fabric_id: fabric_id, available_images: get_images(fabric_id), changeset: changeset)
  end

  def create(conn, %{"fabric_id" => fabric_id, "fabric_image" => fabric_image_params}) do
    case Dictionaries.create_fabric_image(fabric_id, fabric_image_params) do
      {:ok, fabric_image} ->
        conn
        |> put_flash(:info, "Fabric image created successfully.")
        |> redirect(to: fabric_image_path(conn, :show, fabric_id, fabric_image))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", fabric_id: fabric_id, available_images: get_images(fabric_id), changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    fabric_image = Dictionaries.get_fabric_image!(id)
    render(conn, "show.html", fabric_image: fabric_image)
  end

  def edit(conn, %{"id" => id}) do
    fabric_image = Dictionaries.get_fabric_image!(id)
    changeset = Dictionaries.change_fabric_image(fabric_image)
    render(conn, "edit.html", fabric_image: fabric_image, available_images: get_images(fabric_image.fabric_id), changeset: changeset)
  end

  def update(conn, %{"id" => id, "fabric_image" => fabric_image_params}) do
    fabric_image = Dictionaries.get_fabric_image!(id)

    case Dictionaries.update_fabric_image(fabric_image, fabric_image_params) do
      {:ok, fabric_image} ->
        conn
        |> put_flash(:info, "Fabric image updated successfully.")
        |> redirect(to: fabric_image_path(conn, :show, fabric_image.fabric_id, fabric_image))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", fabric_image: fabric_image, available_images: get_images(fabric_image.fabric_id), changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    fabric_image = Dictionaries.get_fabric_image!(id)
    {:ok, _fabric_image} = Dictionaries.delete_fabric_image(fabric_image)

    conn
    |> put_flash(:info, "Fabric image deleted successfully.")
    |> redirect(to: fabric_image_path(conn, :index, fabric_image.fabric_id))
  end
end
