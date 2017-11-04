defmodule DresstilleryWeb.UserControllerTest do
  use DresstilleryWeb.AuthorizedConnCase

  alias Dresstillery.Administration

  @create_attrs %{}

  def fixture(:user) do
    {:ok, user} = Administration.create_user(@create_attrs)
    user
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "show user" do
    setup [:create_user]

    test "shows", %{conn: conn_orig, user: user} do
      conn = get conn_orig, user_path(conn_orig, :show, user)
      assert html_response(conn, 200) =~ "Show User"
    end

    test "renders 404 if not found", %{conn: conn} do
      assert_error_sent 404, fn ->
        get conn, user_path(conn, :show, 123)
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
