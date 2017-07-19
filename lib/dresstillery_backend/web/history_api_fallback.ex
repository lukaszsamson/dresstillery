defmodule DresstilleryBackend.Web.HistoryApiFallback do
  import Plug.Conn

  def init(opts) do
    (opts ++ [only: ~w(index.html)])
    |> Plug.Static.init
  end

  defp html_accepted?(conn) do
    case get_req_header(conn, "accept") do
      [first | _] ->
        first
        |> String.split(",")
        |> Enum.any?(fn mtq ->
          [mt | _] = mtq
          |> String.split(";q=")
          mt == "text/html"
        end)
      [] -> false
    end
  end

  def call(conn, opts) do
    if conn.method in ["GET", "HEAD"] and html_accepted?(conn) and not (conn.request_path |> String.starts_with?("/admin")) do
      %Plug.Conn{conn | path_info: ["index.html"]}
      |> Plug.Static.call(opts)
    else
      conn
    end
  end

end
