defmodule DresstilleryWeb.Api.UserControllerTest do
  use DresstilleryWeb.ConnCase

  alias Dresstillery.Administration


  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "register" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post conn, api_user_path(conn, :register), user: %{login: "test", password: "zxcv"}
      assert json_response(conn, 200)

      # TODO
      # assert %{"id" => id} = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_user_path(conn, :register), user: %{login: "test", password: ""}
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "login" do
    test "renders user when data is valid", %{conn: conn} do
      {:ok, _user} = Administration.register(%{login: "test", password: "zxcv"})

      conn = post conn, api_user_path(conn, :login), user: %{login: "test", password: "zxcv"}
      assert json_response(conn, 200)

      # TODO
      # assert %{"id" => id} = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_user_path(conn, :login), user: %{login: "test", password: ""}
      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  describe "login_facebook" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post conn, api_user_path(conn, :login_facebook), user: %{token: "valid_token"}
      assert json_response(conn, 200)

      # TODO
      # assert %{"id" => id} = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_user_path(conn, :login_facebook), user: %{token: "test"}
      assert json_response(conn, 401)["errors"] != %{}
    end

    test "renders errors when data api down", %{conn: conn} do
      conn = post conn, api_user_path(conn, :login_facebook), user: %{token: "api_down"}
      assert json_response(conn, 503)["errors"] != %{}
    end
  end

  # describe "update user" do
  #   setup [:create_user]
  #
  #   test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
  #     conn = put conn, api_user_path(conn, :update, user), user: @update_attrs
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]
  #
  #     conn = get conn, api_user_path(conn, :show, id)
  #     assert json_response(conn, 200)["data"] == %{
  #       "id" => id}
  #   end
  #
  #   test "renders errors when data is invalid", %{conn: conn, user: user} do
  #     conn = put conn, api_user_path(conn, :update, user), user: @invalid_attrs
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete user" do
  #   setup [:create_user]
  #
  #   test "deletes chosen user", %{conn: conn, user: user} do
  #     conn = delete conn, api_user_path(conn, :delete, user)
  #     assert response(conn, 204)
  #     assert_error_sent 404, fn ->
  #       get conn, api_user_path(conn, :show, user)
  #     end
  #   end
  # end

end
