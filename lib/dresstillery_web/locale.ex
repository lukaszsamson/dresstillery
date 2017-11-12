defmodule DresstilleryWeb.Locale do
  import Plug.Conn
  import Logger

  def init(default), do: default

  def call(conn, default) do
    locale = List.first(extract_locale(conn)) || default

    conn |> assign_locale!(locale)
  end

  defp assign_locale!(conn, value) do
    Logger.debug "Setting locale to #{value}"
    # Apply the locale as a process var and continue
    Gettext.put_locale(DresstilleryWeb.Gettext, value)

    conn
    |> assign(:locale, value)
  end

  defp extract_locale(conn) do
    # Filter for only known locales
    extract_accept_language(conn)
    |> Enum.filter(fn locale ->
         Enum.member?(DresstilleryWeb.Gettext.supported_locales(), locale)
       end)
    |> IO.inspect()
  end

  defp extract_accept_language(conn) do
    case conn |> get_req_header("accept-language") do
      [value | _] ->
        value
        |> String.split(",")
        |> Enum.map(&parse_language_option/1)
        |> Enum.sort(&(&1.quality > &2.quality))
        |> Enum.map(& &1.tag)

      _ ->
        []
    end
  end

  defp parse_language_option(string) do
    captures =
      ~r/^(?<tag>[\w\-]+)(?:;q=(?<quality>[\d\.]+))?$/i
      |> Regex.named_captures(string)

    quality =
      case Float.parse(captures["quality"] || "1.0") do
        {val, _} -> val
        _ -> 1.0
      end

    %{tag: captures["tag"], quality: quality}
  end
end
