defmodule DresstilleryWeb.ImageController do
  use DresstilleryWeb, :controller

  alias Dresstillery.Media
  alias Dresstillery.Media.Image
  @upload_dir Application.app_dir(:dresstillery, Application.fetch_env!(:dresstillery, :upload_directory))

  def index(conn, _params) do
    images = Media.list_images()
    render(conn, "index.html", images: images)
  end

  def new(conn, _params) do
    changeset = Media.change_image(%Image{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"image" => %{"image" => upload = %Plug.Upload{}}}) do
    extension = Path.extname(upload.filename)
    path = @upload_dir
    |> Path.join("#{:crypto.strong_rand_bytes(6) |> Base.url_encode64}.#{extension}")
    File.cp!(upload.path, path)

    case Media.create_image(%{path: path}) do
      {:ok, image} ->
        conn
        |> put_flash(:info, "Image created successfully.")
        |> redirect(to: image_path(conn, :show, image))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, _) do
    changeset = Media.change_image(%Image{})
    render(conn, "new.html", changeset: changeset)
  end

  def show(conn, %{"id" => id}) do
    image = Media.get_image!(id)
    render(conn, "show.html", image: image)
  end

  def delete(conn, %{"id" => id}) do
    image = Media.get_image!(id)
    {:ok, _image} = Media.delete_image(image)
    File.rm!(image.path)

    conn
    |> put_flash(:info, "Image deleted successfully.")
    |> redirect(to: image_path(conn, :index))
  end
end