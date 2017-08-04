defmodule DresstilleryWeb.HistoryApiFallback do
  import Phoenix.Controller

  def init(opts) do
    static_opts = opts
    |> Keyword.fetch!(:static_opts)
    |> Keyword.put(:only, ~w(index.html))
    |> Plug.Static.init

    %{static_opts: static_opts, blacklist: Keyword.get(opts, :blacklist, [])}
  end

  defp html_accepted?(conn) do
    try do
      _ = accepts(conn, ["html"])
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

  defp blacklisted?(conn, blacklist) do
    blacklist
    |> Enum.any?(& conn.request_path |> String.starts_with?(&1))
  end

  def call(conn, %{static_opts: static_opts, blacklist: blacklist}) do
    if conn.method in ["GET", "HEAD"]
      and not file_request?(conn)
      and html_accepted?(conn)
      and not (blacklisted?(conn, blacklist)) do
      %Plug.Conn{conn | path_info: ["index.html"]}
      |> Plug.Static.call(static_opts)
    else
      conn
    end
  end

end
