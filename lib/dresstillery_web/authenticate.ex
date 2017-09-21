defmodule DresstilleryWeb.Authenticate do
  import Plug.Conn
  alias DresstilleryWeb.Router.Helpers, as: RouteHelpers
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, opts) do
    cond do
      conn.assigns[:current_user] -> conn
      user = get_session(conn, :current_user) |> Dresstillery.Administration.get_active_backoffice_user ->
        conn
        |> assign(:current_user, user)
        |> assign(:current_user_permissions, user.permissions |> Enum.map(&(&1.name)) |> MapSet.new)
      true -> maybe_auth_error(conn, Keyword.get(opts, :require_session, true))
    end
  end

  defp maybe_auth_error(conn, false), do: conn
  defp maybe_auth_error(conn, true) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: RouteHelpers.session_path(conn, :login_page))
    |> halt
  end
end
