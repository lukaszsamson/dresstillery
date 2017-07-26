defmodule Dresstillery.AdministrationTest do
  use Dresstillery.DataCase

  alias Dresstillery.Administration

  describe "backoffice_users" do
    alias Dresstillery.Administration.BackofficeUser

    @valid_attrs %{login: "some login", permissions: [%{name: "manage_users"}, %{name: "manage_orders"}]}
    @update_attrs %{login: "some updated login", permissions: [%{name: "manage_users"}, %{name: "manage_backoffice_users"}]}
    @invalid_attrs %{login: nil}

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
      assert Comeonin.Bcrypt.checkpw("p@ssw0rd", backoffice_user.password)
      refute backoffice_user.tfa_code
      assert backoffice_user.active
      assert [_,_] = backoffice_user.permissions
      assert backoffice_user.permissions |> Enum.any?(& &1.name == "manage_users")
      assert backoffice_user.permissions |> Enum.any?(& &1.name == "manage_orders")
    end

    test "create_backoffice_user/1 login unique" do
      {:ok, %BackofficeUser{}} = Administration.create_backoffice_user(@valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Administration.create_backoffice_user(@valid_attrs)
    end

    test "create_backoffice_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Administration.create_backoffice_user(@invalid_attrs)
    end

    test "update_backoffice_user/2 with valid data updates the backoffice_user" do
      backoffice_user = backoffice_user_fixture()
      assert {:ok, backoffice_user} = Administration.update_backoffice_user(backoffice_user, @update_attrs)
      assert %BackofficeUser{} = backoffice_user
      assert backoffice_user.login == "some updated login"
      assert [_,_] = backoffice_user.permissions
      assert backoffice_user.permissions |> Enum.any?(& &1.name == "manage_users")
      assert backoffice_user.permissions |> Enum.any?(& &1.name == "manage_backoffice_users")
    end

    test "update_backoffice_user/2 login unique" do
      {:ok, %BackofficeUser{}} = Administration.create_backoffice_user(@update_attrs)
      backoffice_user = backoffice_user_fixture()
      assert {:error, %Ecto.Changeset{}} = Administration.update_backoffice_user(backoffice_user, @update_attrs)
    end

    test "update_backoffice_user/2 with invalid data returns error changeset" do
      backoffice_user = backoffice_user_fixture()
      assert {:error, %Ecto.Changeset{}} = Administration.change_password(backoffice_user, @invalid_attrs)
    end

    test "change_password/2 with valid data updates the backoffice_user" do
      backoffice_user = backoffice_user_fixture()
      assert {:ok, backoffice_user} = Administration.change_password(backoffice_user, %{password: "abc", tfa_code: "123"})
      assert %BackofficeUser{} = backoffice_user
      assert backoffice_user.password == "abc"
      assert backoffice_user.tfa_code == "123"
    end

    test "change_password/2 with invalid data returns error changeset" do
      backoffice_user = backoffice_user_fixture()
      assert {:error, %Ecto.Changeset{}} = Administration.change_password(backoffice_user, %{})
    end

    test "reset_password/2 updates the backoffice_user" do
      backoffice_user = backoffice_user_fixture()
      assert {:ok, backoffice_user} = Administration.reset_password(backoffice_user)
      assert %BackofficeUser{} = backoffice_user
      assert Comeonin.Bcrypt.checkpw("p@ssw0rd", backoffice_user.password)
      refute backoffice_user.tfa_code
    end

    test "deactivate/1 sets inactive" do
      backoffice_user = backoffice_user_fixture()
      assert {:ok, backoffice_user} = Administration.deactivate(backoffice_user)
      refute backoffice_user.active
    end

    test "change_backoffice_user/1 returns a backoffice_user changeset" do
      backoffice_user = backoffice_user_fixture()
      assert %Ecto.Changeset{} = Administration.change_backoffice_user(backoffice_user)
    end
  end
end
