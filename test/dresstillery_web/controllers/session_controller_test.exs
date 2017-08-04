defmodule DresstilleryWeb.SessionControllerTest do
  use DresstilleryWeb.ConnCase

  alias Dresstillery.Administration.BackofficeUser
  alias Dresstillery.Repo

  test "GET /admin", %{conn: conn} do
    conn = get conn, page_path(conn, :index)
    assert redirected_to(conn) == session_path(conn, :login_page)
  end

  test "displays login page", %{conn: conn} do
    conn = get conn, session_path(conn, :login_page)
    assert html_response(conn, 200) =~ "Login"
  end

  test "login with valid credentials should redirect to tfa page", %{conn: conn} do
    create_user()
    conn = post conn, session_path(conn, :login), user_login: %{login: "admin@example.com", password: "p@ssw0rd"}
    assert redirected_to(conn) == session_path(conn, :tfa_page)
    assert get_session(conn, :tfa_user) == 332
  end

  test "login with valid credentials should not succeed for deactivated user", %{conn: conn} do
    create_user(false)
    conn = post conn, session_path(conn, :login), user_login: %{login: "admin@example.com", password: "p@ssw0rd"}
    assert html_response(conn, 200) =~ "Login"
  end

  test "login with valid credentials for seed user should login and redirect to change password page", %{conn: conn} do
    create_seed_user()
    conn = post conn, session_path(conn, :login), user_login: %{login: "admin@example.com", password: "p@ssw0rd"}
    assert get_session(conn, :current_user) == 332
    assert redirected_to(conn) == session_path(conn, :change_password_page)
    assert get_flash(conn, :info) == "Password change required"
  end

  test "login with invalid password should not succeed", %{conn: conn} do
    create_user()
    conn = post conn, session_path(conn, :login), user_login: %{login: "admin@example.com", password: "asdasd"}
    assert html_response(conn, 200) =~ "Login"
  end

  test "login with invalid user should not succeed", %{conn: conn} do
    conn = post conn, session_path(conn, :login), user_login: %{login: "admin1@example.com", password: "asdasd"}
    assert html_response(conn, 200) =~ "Login"
  end

  test "login with invalid data should not succeed", %{conn: conn} do
    conn = post conn, session_path(conn, :login), user_login: %{login: "admin@example.com", password: ""}
    assert html_response(conn, 200) =~ "Login"
  end

  test "get tfa page should redirect if no session", %{conn: conn} do
    conn = get conn, session_path(conn, :tfa_page)
    assert redirected_to(conn) == session_path(conn, :login_page)
  end

  defp recycle_cookies(new_conn, old_conn) do
    Enum.reduce Plug.Conn.fetch_cookies(old_conn).cookies, new_conn, fn
      {key, value}, acc -> put_req_cookie(acc, to_string(key), value)
    end
  end

  defp create_user(active \\ true) do
    Repo.insert! %BackofficeUser{id: 332, login: "admin@example.com", password: "$2b$12$R3nBGCoa53vS4M1XgBpTgu7LROinWVaYEhKLG0Xo77Nghx1DtRVu.",
      tfa_code: "MFRGGZDFMZTWQ2LK", active: active}
  end

  defp create_seed_user do
    Repo.insert! %BackofficeUser{id: 332, login: "admin@example.com", password: "$2b$12$R3nBGCoa53vS4M1XgBpTgu7LROinWVaYEhKLG0Xo77Nghx1DtRVu.",
      active: true}
  end

  test "tfa page should display if valid session", %{conn: conn} do
    create_user()
    oldconn = post conn, session_path(conn, :login), user_login: %{login: "admin@example.com", password: "p@ssw0rd"}

    conn = conn
    |> recycle_cookies(oldconn)
    |> get(session_path(conn, :tfa_page))
    assert html_response(conn, 200) =~ "Two factor auth"
  end

  test "tfa login should succeed and redirect if valid code used", %{conn: conn} do
    create_user()
    oldconn = post conn, session_path(conn, :login), user_login: %{login: "admin@example.com", password: "p@ssw0rd"}

    conn = conn
    |> recycle_cookies(oldconn)
    |> post(session_path(conn, :tfa, tfa_code: %{code: :pot.totp("MFRGGZDFMZTWQ2LK")}))
    assert redirected_to(conn) == page_path(conn, :index)
    assert get_session(conn, :current_user) == 332
    assert get_session(conn, :tfa_user) == nil
    assert get_flash(conn, :info) == "Logged in"
  end

  defp invalid(secret) do
    code = "000000"
    if code != :pot.totp(secret), do: code, else: "000001"
  end

  test "tfa login should not succeed if invalid code used", %{conn: conn} do
    create_user()
    oldconn = post conn, session_path(conn, :login), user_login: %{login: "admin@example.com", password: "p@ssw0rd"}

    conn = conn
    |> recycle_cookies(oldconn)
    |> post(session_path(conn, :tfa, tfa_code: %{code: invalid("MFRGGZDFMZTWQ2LK")}))
    assert html_response(conn, 200) =~ "Two factor auth"
  end

  test "tfa login should not succeed if no session", %{conn: conn} do
    create_user()

    conn = conn
    |> post(session_path(conn, :tfa, tfa_code: %{code: invalid("MFRGGZDFMZTWQ2LK")}))
    assert redirected_to(conn) == session_path(conn, :login_page)
  end

  test "logout should clear session and redirect when fully logged in", %{conn: conn} do
    create_user()
    oldconn = post conn, session_path(conn, :login), user_login: %{login: "admin@example.com", password: "p@ssw0rd"}

    oldconn1 = conn
    |> recycle_cookies(oldconn)
    |> post(session_path(conn, :tfa, tfa_code: %{code: :pot.totp("MFRGGZDFMZTWQ2LK")}))

    conn = conn
    |> recycle_cookies(oldconn1)
    |> post(session_path(conn, :logout))

    assert redirected_to(conn) == session_path(conn, :login_page)
    assert get_session(conn, :current_user) == nil
    assert get_session(conn, :tfa_user) == nil
    assert conn.halted
  end

  test "logout should clear session and redirect when partially logged in", %{conn: conn} do
    create_user()
    oldconn = post conn, session_path(conn, :login), user_login: %{login: "admin@example.com", password: "p@ssw0rd"}

    conn = conn
    |> recycle_cookies(oldconn)
    |> post(session_path(conn, :logout))

    assert redirected_to(conn) == session_path(conn, :login_page)
    assert get_session(conn, :current_user) == nil
    assert get_session(conn, :tfa_user) == nil
    assert conn.halted
  end

  test "logout should clear session and redirect when not logged in", %{conn: conn} do
    conn = conn
    |> post(session_path(conn, :logout))

    assert redirected_to(conn) == session_path(conn, :login_page)
    assert get_session(conn, :current_user) == nil
    assert get_session(conn, :tfa_user) == nil
    assert conn.halted
  end

  test "getting /admin possible when fully logged in", %{conn: conn} do
    create_user()
    oldconn = post conn, session_path(conn, :login), user_login: %{login: "admin@example.com", password: "p@ssw0rd"}

    oldconn1 = conn
    |> recycle_cookies(oldconn)
    |> post(session_path(conn, :tfa, tfa_code: %{code: :pot.totp("MFRGGZDFMZTWQ2LK")}))

    conn = conn
    |> recycle_cookies(oldconn1)
    |> get(page_path(conn, :index))

    assert html_response(conn, 200) =~ "Dresstillery"
  end

  test "getting restricted page not possible if not authorized", %{conn: conn} do
    create_user()
    oldconn = post conn, session_path(conn, :login), user_login: %{login: "admin@example.com", password: "p@ssw0rd"}

    oldconn1 = conn
    |> recycle_cookies(oldconn)
    |> post(session_path(conn, :tfa, tfa_code: %{code: :pot.totp("MFRGGZDFMZTWQ2LK")}))

    conn = conn
    |> recycle_cookies(oldconn1)
    |> get(backoffice_user_path(conn, :index))

    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "getting password change possible when fully logged in", %{conn: conn} do
    create_user()
    oldconn = post conn, session_path(conn, :login), user_login: %{login: "admin@example.com", password: "p@ssw0rd"}

    oldconn1 = conn
    |> recycle_cookies(oldconn)
    |> post(session_path(conn, :tfa, tfa_code: %{code: :pot.totp("MFRGGZDFMZTWQ2LK")}))

    conn = conn
    |> recycle_cookies(oldconn1)
    |> get(session_path(conn, :change_password_page))

    assert html_response(conn, 200) =~ "Change password"
  end

  test "password change should succeed if valid data entered", %{conn: conn} do
    create_user()
    oldconn = post conn, session_path(conn, :login), user_login: %{login: "admin@example.com", password: "p@ssw0rd"}

    oldconn1 = conn
    |> recycle_cookies(oldconn)
    |> post(session_path(conn, :tfa, tfa_code: %{code: :pot.totp("MFRGGZDFMZTWQ2LK")}))

    conn = conn
    |> recycle_cookies(oldconn1)
    |> post(session_path(conn, :change_password), change_password: %{password: "p@ssw0rd",
      new_password: "qwerttyrqwer", new_password_confirmation: "qwerttyrqwer", tfa_code: "2345234525", code: :pot.totp("MFRGGZDFMZTWQ2LK")})
    assert redirected_to(conn) == page_path(conn, :index)
    assert get_flash(conn, :info) == "Password changed"
    updated_user = Repo.get(BackofficeUser, 332)

    assert updated_user.tfa_code == "2345234525"
    assert Comeonin.Bcrypt.checkpw("qwerttyrqwer", updated_user.password) == true
  end

  test "password change should succeed if valid data entered for seed user", %{conn: conn} do
    create_seed_user()
    oldconn = post conn, session_path(conn, :login), user_login: %{login: "admin@example.com", password: "p@ssw0rd"}

    conn = conn
    |> recycle_cookies(oldconn)
    |> post(session_path(conn, :change_password), change_password: %{password: "p@ssw0rd",
      new_password: "qwerttyrqwer", new_password_confirmation: "qwerttyrqwer", tfa_code: "2345234525"})
    assert redirected_to(conn) == page_path(conn, :index)
    assert get_flash(conn, :info) == "Password changed"
    updated_user = Repo.get(BackofficeUser, 332)

    assert updated_user.tfa_code == "2345234525"
    assert Comeonin.Bcrypt.checkpw("qwerttyrqwer", updated_user.password) == true
  end

  test "password change should fail if invalid tfa code", %{conn: conn} do
    create_user()
    oldconn = post conn, session_path(conn, :login), user_login: %{login: "admin@example.com", password: "p@ssw0rd"}

    oldconn1 = conn
    |> recycle_cookies(oldconn)
    |> post(session_path(conn, :tfa, tfa_code: %{code: :pot.totp("MFRGGZDFMZTWQ2LK")}))

    conn = conn
    |> recycle_cookies(oldconn1)
    |> post(session_path(conn, :change_password), change_password: %{password: "p@ssw0rd",
      new_password: "qwerttyrqwer", new_password_confirmation: "qwerttyrqwer", tfa_code: "2345234525", code: invalid("MFRGGZDFMZTWQ2LK")})
    assert html_response(conn, 200) =~ "Change password"
  end

  test "password change should fail if invalid old password entered", %{conn: conn} do
    create_user()
    oldconn = post conn, session_path(conn, :login), user_login: %{login: "admin@example.com", password: "p@ssw0rd"}

    oldconn1 = conn
    |> recycle_cookies(oldconn)
    |> post(session_path(conn, :tfa, tfa_code: %{code: :pot.totp("MFRGGZDFMZTWQ2LK")}))

    conn = conn
    |> recycle_cookies(oldconn1)
    |> post(session_path(conn, :change_password), change_password: %{password: "p@ssw0rd2",
      new_password: "qwerttyrqwer", new_password_confirmation: "qwerttyrqwer", tfa_code: "2345234525"})

    assert html_response(conn, 200) =~ "Change password"
  end

  test "password change should fail if invalid password confirmation does not match", %{conn: conn} do
    create_user()
    oldconn = post conn, session_path(conn, :login), user_login: %{login: "admin@example.com", password: "p@ssw0rd"}

    oldconn1 = conn
    |> recycle_cookies(oldconn)
    |> post(session_path(conn, :tfa, tfa_code: %{code: :pot.totp("MFRGGZDFMZTWQ2LK")}))

    conn = conn
    |> recycle_cookies(oldconn1)
    |> post(session_path(conn, :change_password), change_password: %{password: "p@ssw0rd",
      new_password: "qwerttyrqwer", new_password_confirmation: "qwerttyrqwe", tfa_code: "2345234525"})

    assert html_response(conn, 200) =~ "Change password"
  end

end
