defmodule DresstilleryWeb.LayoutView do
  use DresstilleryWeb, :view
  import Plug.Conn

  def can_logout(conn) do
    cond do
      get_session(conn, :tfa_user) -> true
      get_session(conn, :current_user) -> true
      true -> false
    end
  end

  def can_change_password(conn) do
    cond do
      get_session(conn, :current_user) -> true
      true -> false
    end
  end
end
