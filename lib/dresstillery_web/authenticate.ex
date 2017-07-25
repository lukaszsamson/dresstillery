defmodule DresstilleryBackendWeb.Authenticate do
  import Plug.Conn
  alias DresstilleryBackendWeb.Router.Helpers, as: RouteHelpers
  import Phoenix.Controller

  alias DresstilleryBackend.Repo
  import Ecto.Query
  alias DresstilleryBackend.BackofficeUser

  def init(opts), do: opts

  def call(conn, _opts) do
    cond do
      conn.assigns[:current_user] -> conn
      user = get_session(conn, :current_user) |> find_user ->
        conn
        |> assign(:current_user, user)
        |> assign(:current_user_permissions, user.permissions |> Enum.map(&(&1.name)) |> MapSet.new)
      true -> auth_error!(conn)
    end
  end

  defp find_user(nil), do: nil

  defp find_user(id) do
    Repo.one from u in BackofficeUser,
           left_join: p in assoc(u, :permissions),
           where: u.id == ^id and u.active == true,
           preload: [permissions: p]
  end

  defp auth_error!(conn) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: RouteHelpers.session_path(conn, :login_page))
    |> halt
  end
end
