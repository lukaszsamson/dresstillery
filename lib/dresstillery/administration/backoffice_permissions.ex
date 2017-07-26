defmodule Dresstillery.Administration.BackofficePermissions do
  def all do
    ~w(manage_users manage_backoffice_users manage_orders)
  end
end
