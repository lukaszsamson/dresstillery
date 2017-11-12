defmodule Dresstillery.AdministrationTest do
  use Dresstillery.DataCase

  alias Dresstillery.Administration

  describe "backoffice_users" do
    alias Dresstillery.Administration.BackofficeUser

    @valid_attrs %{
      login: "some login",
      permissions: [%{name: "manage_users"}, %{name: "manage_orders"}]
    }
    @update_attrs %{
      login: "some updated login",
      permissions: [%{name: "manage_users"}, %{name: "manage_backoffice_users"}]
    }
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
      assert {:ok, %BackofficeUser{} = backoffice_user} =
               Administration.create_backoffice_user(@valid_attrs)

      assert backoffice_user.login == "some login"
      assert Comeonin.Bcrypt.checkpw("p@ssw0rd", backoffice_user.password)
      refute backoffice_user.tfa_code
      assert backoffice_user.active
      assert [_, _] = backoffice_user.permissions
      assert backoffice_user.permissions |> Enum.any?(&(&1.name == "manage_users"))
      assert backoffice_user.permissions |> Enum.any?(&(&1.name == "manage_orders"))
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

      assert {:ok, backoffice_user} =
               Administration.update_backoffice_user(backoffice_user, @update_attrs)

      assert %BackofficeUser{} = backoffice_user
      assert backoffice_user.login == "some updated login"
      assert [_, _] = backoffice_user.permissions
      assert backoffice_user.permissions |> Enum.any?(&(&1.name == "manage_users"))
      assert backoffice_user.permissions |> Enum.any?(&(&1.name == "manage_backoffice_users"))
    end

    test "update_backoffice_user/2 login unique" do
      {:ok, %BackofficeUser{}} = Administration.create_backoffice_user(@update_attrs)
      backoffice_user = backoffice_user_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Administration.update_backoffice_user(backoffice_user, @update_attrs)
    end

    test "update_backoffice_user/2 with invalid data returns error changeset" do
      backoffice_user = backoffice_user_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Administration.change_password(backoffice_user, @invalid_attrs)
    end

    test "change_password/2 with valid data updates the backoffice_user" do
      backoffice_user = backoffice_user_fixture()

      assert {:ok, backoffice_user} =
               Administration.change_password(backoffice_user, %{password: "abc", tfa_code: "123"})

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

  describe "users" do
    alias Dresstillery.Administration.User
    alias Dresstillery.Administration.FacebookAuthentication

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Administration.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Administration.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Administration.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = _user} = Administration.create_user(@valid_attrs)
      # assert user.identity_provider == "some identity_provider"
    end

    @tag :pending
    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Administration.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Administration.update_user(user, @update_attrs)
      assert %User{} = user
      # assert user.identity_provider == "some updated identity_provider"
    end

    @tag :pending
    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Administration.update_user(user, @invalid_attrs)
      assert user == Administration.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Administration.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Administration.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Administration.change_user(user)
    end
  end

  describe "facebook" do
    alias Dresstillery.Administration.User
    alias Dresstillery.Administration.FacebookAuthentication

    test "login_facebook/1 creates new user if token valid" do
      assert {:ok, user} = Administration.login_facebook("valid_token")
      assert user.facebook_authentication.external_id == "12345"
    end

    test "login_facebook/1 returns error if token invalid" do
      assert {:error, :token_not_valid} = Administration.login_facebook("invalid")
    end

    test "login_facebook/1 returns error if api not available" do
      assert {:error, :facebook_api_error} = Administration.login_facebook("api_down")
    end

    test "login_facebook/1 returns existing user if token valid" do
      user = user_fixture()

      %FacebookAuthentication{}
      |> FacebookAuthentication.changeset(%{external_id: "12345"})
      |> Ecto.Changeset.put_assoc(:user, user)
      |> Repo.insert!()

      assert {:ok, existing_user} = Administration.login_facebook("valid_token")
      assert user.id == existing_user.id
      assert existing_user.facebook_authentication.external_id == "12345"
    end
  end

  describe "password" do
    alias Dresstillery.Administration.User
    alias Dresstillery.Administration.PasswordAuthentication

    test "register/1 creates new user" do
      assert {:ok, user} = Administration.register(%{login: "login", password: "password"})
      assert user.password_authentication.login == "login"
      assert Comeonin.Bcrypt.checkpw("password", user.password_authentication.password)
    end

    test "login/1 gets existing user if pass valid" do
      user = user_fixture()

      %PasswordAuthentication{}
      |> PasswordAuthentication.changeset(%{login: "login", password: "p@ssw0rd"})
      |> Ecto.Changeset.put_assoc(:user, user)
      |> Repo.insert!()

      assert {:ok, user} = Administration.login(%{login: "login", password: "p@ssw0rd"})
      assert user.password_authentication.login == "login"
    end

    test "login/1 fails if pass not valid" do
      user = user_fixture()

      %PasswordAuthentication{}
      |> PasswordAuthentication.changeset(%{login: "login", password: "p@ssw0rd"})
      |> Ecto.Changeset.put_assoc(:user, user)
      |> Repo.insert!()

      assert {:error, %{errors: [password: {"invalid login or password", []}]}} =
               Administration.login(%{login: "login", password: "go"})
    end

    test "login/1 fails if login not valid" do
      assert {:error, %{errors: [password: {"invalid login or password", []}]}} =
               Administration.login(%{login: "login", password: "go"})
    end
  end
end
