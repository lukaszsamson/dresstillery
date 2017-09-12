defmodule DresstilleryWeb.FabricController do
  use DresstilleryWeb, :controller

  alias Dresstillery.Dictionaries
  alias Dresstillery.Dictionaries.Fabric

  def index(conn, _params) do
    fabrics = Dictionaries.list_fabrics()
    render(conn, "index.html", fabrics: fabrics)
  end

  def new(conn, _params) do
    changeset = Dictionaries.change_fabric(%Fabric{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"fabric" => fabric_params}) do
    case Dictionaries.create_fabric(fabric_params) do
      {:ok, fabric} ->
        conn
        |> put_flash(:info, "Fabric created successfully.")
        |> redirect(to: fabric_path(conn, :show, fabric))
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
    changeset = Dictionaries.change_fabric(fabric)
    render(conn, "edit.html", fabric: fabric, changeset: changeset)
  end

  def update(conn, %{"id" => id, "fabric" => fabric_params}) do
    fabric = Dictionaries.get_fabric!(id)

    case Dictionaries.update_fabric(fabric, fabric_params) do
      {:ok, fabric} ->
        conn
        |> put_flash(:info, "Fabric updated successfully.")
        |> redirect(to: fabric_path(conn, :show, fabric))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", fabric: fabric, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    fabric = Dictionaries.get_fabric!(id)
    {:ok, _fabric} = Dictionaries.delete_fabric(fabric)

    conn
    |> put_flash(:info, "Fabric deleted successfully.")
    |> redirect(to: fabric_path(conn, :index))
  end
end
