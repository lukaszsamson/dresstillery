defmodule DresstilleryWeb.Authorize do
  import Plug.Conn
  import Phoenix.Controller
  alias DresstilleryWeb.Router.Helpers, as: RouteHelpers

  def init(opts) do
    %{require: opts
    |> Keyword.fetch!(:require)
    |> MapSet.new
    }
  end

  def call(conn, %{require: opts}) do
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
    |> redirect(to: RouteHelpers.page_path(conn, :index))
    |> halt
  end
end
