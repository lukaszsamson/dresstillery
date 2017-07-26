defmodule DresstilleryWeb.Authenticate do
  import Plug.Conn
  alias DresstilleryWeb.Router.Helpers, as: RouteHelpers
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    cond do
      conn.assigns[:current_user] -> conn
      user = get_session(conn, :current_user) |> Dresstillery.Administration.get_active_backoffice_user ->
        conn
        |> assign(:current_user, user)
        |> assign(:current_user_permissions, user.permissions |> Enum.map(&(&1.name)) |> MapSet.new)
      true -> auth_error!(conn)
    end
  end

  defp auth_error!(conn) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: RouteHelpers.session_path(conn, :login_page))
    |> halt
  end
end
