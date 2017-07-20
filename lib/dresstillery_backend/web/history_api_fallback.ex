defmodule DresstilleryBackend.Web.HistoryApiFallback do
  import Phoenix.Controller

  def init(opts) do
    (opts ++ [only: ~w(index.html)])
    |> Plug.Static.init
  end

  defp html_accepted?(conn) do
    try do
      accepts(conn, ["html"])
      true
    rescue
      Phoenix.NotAcceptableError -> false
    end
  end

  defp file_request?(conn) do
    case conn.path_info |> Enum.at(-1) do
      nil -> false
      last -> String.contains?(last, ".")
    end
  end

  def call(conn, opts) do
    if conn.method in ["GET", "HEAD"]
      and not file_request?(conn)
      and html_accepted?(conn)
      and not (conn.request_path |> String.starts_with?("/admin")) do
      %Plug.Conn{conn | path_info: ["index.html"]}
      |> Plug.Static.call(opts)
    else
      conn
    end
  end

end
