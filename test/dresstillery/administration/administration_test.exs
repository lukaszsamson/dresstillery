defmodule Dresstillery.AdministrationTest do
  use Dresstillery.DataCase

  alias Dresstillery.Administration

  describe "backoffice_users" do
    alias Dresstillery.Administration.BackofficeUser

    @valid_attrs %{login: "some login", password: "some password", tfa_code: "some tfa_code"}
    @update_attrs %{login: "some updated login", password: "some updated password", tfa_code: "some updated tfa_code"}
    @invalid_attrs %{login: nil, password: nil, tfa_code: nil}

    def backoffice_user_fixture(attrs \\ %{}) do
      {:ok, backoffice_user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Administration.create_backoffice_user()

      backoffice_user
    end

    test "list_backoffice_users/0 returns all backoffice_users" do
      backoffice_user = backoffice_user_fixture()
      assert Administration.list_backoffice_users() == [backoffice_user]
    end

    test "get_backoffice_user!/1 returns the backoffice_user with given id" do
      backoffice_user = backoffice_user_fixture()
      assert Administration.get_backoffice_user!(backoffice_user.id) == backoffice_user
    end

    test "create_backoffice_user/1 with valid data creates a backoffice_user" do
      assert {:ok, %BackofficeUser{} = backoffice_user} = Administration.create_backoffice_user(@valid_attrs)
      assert backoffice_user.login == "some login"
      assert backoffice_user.password == "some password"
      assert backoffice_user.tfa_code == "some tfa_code"
    end

    test "create_backoffice_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Administration.create_backoffice_user(@invalid_attrs)
    end

    test "update_backoffice_user/2 with valid data updates the backoffice_user" do
      backoffice_user = backoffice_user_fixture()
      assert {:ok, backoffice_user} = Administration.update_backoffice_user(backoffice_user, @update_attrs)
      assert %BackofficeUser{} = backoffice_user
      assert backoffice_user.login == "some updated login"
      assert backoffice_user.password == "some updated password"
      assert backoffice_user.tfa_code == "some updated tfa_code"
    end

    test "update_backoffice_user/2 with invalid data returns error changeset" do
      backoffice_user = backoffice_user_fixture()
      assert {:error, %Ecto.Changeset{}} = Administration.update_backoffice_user(backoffice_user, @invalid_attrs)
      assert backoffice_user == Administration.get_backoffice_user!(backoffice_user.id)
    end

    test "delete_backoffice_user/1 deletes the backoffice_user" do
      backoffice_user = backoffice_user_fixture()
      assert {:ok, %BackofficeUser{}} = Administration.delete_backoffice_user(backoffice_user)
      assert_raise Ecto.NoResultsError, fn -> Administration.get_backoffice_user!(backoffice_user.id) end
    end

    test "change_backoffice_user/1 returns a backoffice_user changeset" do
      backoffice_user = backoffice_user_fixture()
      assert %Ecto.Changeset{} = Administration.change_backoffice_user(backoffice_user)
    end
  end
end
