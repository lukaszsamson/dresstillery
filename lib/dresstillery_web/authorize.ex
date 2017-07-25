defmodule DresstilleryBackendWeb.Authorize do
  import Plug.Conn
  import Phoenix.Controller
  alias DresstilleryBackendWeb.Router.Helpers, as: RouteHelpers

  def init(opts) do
    MapSet.new opts
  end

  def call(conn, opts) do
    permissions = conn.assigns[:current_user_permissions]
    if MapSet.subset? opts, permissions do
      conn
    else
      handle_error(conn, opts)
    end
  end

  defp handle_error(conn, _opts) do
    conn
    |> put_flash(:error, "Unauthorized")
    |> redirect(to: RouteHelpers.session_path(conn, :login_page))
    |> halt
  end
end
