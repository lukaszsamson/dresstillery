defmodule DresstilleryWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use DresstilleryWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(DresstilleryWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(DresstilleryWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :facebook_api_error}) do
    conn
    |> put_status(:service_unavailable)
    |> put_view(DresstilleryWeb.ErrorView)
    |> render(:"503")
  end

  def call(conn, {:error, :token_not_valid}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(DresstilleryWeb.ErrorView)
    |> render(:token_not_valid)
  end
end
