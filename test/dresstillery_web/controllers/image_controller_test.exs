defmodule DresstilleryWeb.ImageControllerTest do
  use DresstilleryWeb.AuthorizedConnCase
  require Logger
  alias Dresstillery.Media

  @create_attrs %{image: %Plug.Upload{path: Application.app_dir(:dresstillery, "/priv/fixture/example.png"), filename: "example.png"}}
  @invalid_attrs %{}

  setup do
    on_exit fn ->
      _ = Application.app_dir(:dresstillery, "/priv/fixture/uploads")
      |> File.ls!
      |> Enum.filter(& Path.extname(&1) == ".png")
      |> Enum.each(fn p ->
        case File.rm(Path.join(Application.app_dir(:dresstillery, "/priv/fixture/uploads"), p)) do
          :ok -> :ok
          error -> Logger.warn "Test file #{p} rm failed with #{inspect error}"
        end
      end)
      :ok
    end
    :ok
  end


  describe "index" do
    test "lists all images", %{conn: conn} do
      conn = get conn, image_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Images"
    end
  end

  describe "new image" do
    test "renders form", %{conn: conn} do
      conn = get conn, image_path(conn, :new)
      assert html_response(conn, 200) =~ "New Image"
    end
  end

  describe "create image" do
    test "redirects to show when data is valid", %{conn: conn_orig} do
      conn = post conn_orig, image_path(conn_orig, :create), image: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == image_path(conn, :show, id)

      conn = get conn_orig, image_path(conn_orig, :show, id)
      assert html_response(conn, 200) =~ "Show Image"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, image_path(conn, :create), image: @invalid_attrs
      assert html_response(conn, 200) =~ "New Image"
    end

    test "can get image", %{conn: conn_orig} do
      conn = post conn_orig, image_path(conn_orig, :create), image: @create_attrs

      assert %{id: id} = redirected_params(conn)

      image = Media.get_image!(id)

      conn = get conn_orig, DresstilleryWeb.ImageView.image_src(image)
      assert response(conn, 200)
    end

    test "non existing results in 404", %{conn: conn_orig} do
      assert_error_sent 404, fn ->
        get conn_orig, "/media/abc.jpg"
      end
    end
  end

  describe "delete image" do

    test "deletes chosen image", %{conn: conn_orig} do
      conn = post conn_orig, image_path(conn_orig, :create), image: @create_attrs
      assert %{id: id} = redirected_params(conn)

      conn = delete conn_orig, image_path(conn_orig, :delete, id)
      assert redirected_to(conn) == image_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn_orig, image_path(conn_orig, :show, id)
      end
    end
  end

end
