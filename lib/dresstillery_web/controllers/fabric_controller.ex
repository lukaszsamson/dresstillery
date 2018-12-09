defmodule DresstilleryWeb.FabricController do
  use DresstilleryWeb, :controller

  alias Dresstillery.Dictionaries
  alias Dresstillery.Dictionaries.Fabric

  def ingridients_to_string(ingridients) do
    ingridients
    |> Enum.map(& "#{&1.name}-#{&1.percentage}")
    |> Enum.join(",")
  end

  def ingridients_from_string(nil), do: []
  def ingridients_from_string(ingridients) do
    ingridients
    |> String.split(",")
    |> Enum.map(fn ing ->
      spli = ing |> String.split("-")
      %{"name" => spli |> Enum.at(0), "percentage" => spli |> Enum.at(1)}
    end)
  end

  defp prepare_ingridients(fabric_params) do
    fabric_params
    |> Map.put("ingridients", ingridients_from_string fabric_params["ingridients_string"])
  end

  def index(conn, _params) do
    fabrics = Dictionaries.list_fabrics()
    render(conn, "index.html", fabrics: fabrics)
  end

  def new(conn, _params) do
    changeset = Dictionaries.change_fabric(%Fabric{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"fabric" => fabric_params}) do
    fabric_params = prepare_ingridients fabric_params
    case Dictionaries.create_fabric(fabric_params) do
      {:ok, fabric} ->
        conn
        |> put_flash(:info, "Fabric created successfully.")
        |> redirect(to: Routes.fabric_path(conn, :show, fabric))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    fabric = Dictionaries.get_fabric!(id)
    render(conn, "show.html", fabric: fabric)
  end

  def edit(conn, %{"id" => id}) do
    fabric = Dictionaries.get_fabric!(id)
    fabric = fabric
    |> Map.put(:ingridients_string, ingridients_to_string(fabric.ingridients))
    changeset = Dictionaries.change_fabric(fabric)
    render(conn, "edit.html", fabric: fabric, changeset: changeset)
  end

  def update(conn, %{"id" => id, "fabric" => fabric_params}) do
    fabric = Dictionaries.get_fabric!(id)

    fabric_params = prepare_ingridients fabric_params

    case Dictionaries.update_fabric(fabric, fabric_params) do
      {:ok, fabric} ->
        conn
        |> put_flash(:info, "Fabric updated successfully.")
        |> redirect(to: Routes.fabric_path(conn, :show, fabric))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", fabric: fabric, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    fabric = Dictionaries.get_fabric!(id)
    {:ok, _fabric} = Dictionaries.delete_fabric(fabric)

    conn
    |> put_flash(:info, "Fabric deleted successfully.")
    |> redirect(to: Routes.fabric_path(conn, :index))
  end
end
