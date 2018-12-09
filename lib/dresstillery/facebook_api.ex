defmodule Dresstillery.FacebookApi do
  require Logger
  @conf Application.fetch_env! :dresstillery, :oauth
  @access_token (@conf |> Keyword.fetch!(:facebook_app_id)) <> "|" <> (@conf |> Keyword.fetch!(:facebook_app_secret))
  @url @conf |> Keyword.fetch!(:facebook_verify_token_url)

  def is_valid(nil), do: false
  def is_valid(""), do: false
  def is_valid(token) do
    do_request(token, 0)
  end

  defp do_request(token, cnt) do
    try do
      do_request(token)
    rescue
      e in HTTPoison.Error ->
        Logger.error "Dresstillery.FacebookApi.is_valid error: #{e.reason}"
        if cnt < 3 do
          Process.sleep(50 * (cnt + 1) * (cnt + 1))
          do_request(token, cnt + 1)
        else
          :error
        end
    end
  end

  defp do_request(token) do
    query = [input_token: token, access_token: @access_token]
    headers = [{"Connection", "keep-alive"}]
    response = HTTPoison.get!(@url, headers, params: query)
    if response.status_code >= 200 and response.status_code < 300 do
      :ok
    else
      raise HTTPoison.Error, reason: "Dresstillery.FacebookApi.is_valid failed with code #{response.status_code}, #{response.body}"
    end
    Logger.info "Dresstillery.FacebookApi.is_valid response: #{response.status_code}, #{response.body}"
    parsed = Jason.decode!(response.body)
    case parsed["data"]["is_valid"] do
      true -> {true, parsed["data"]["user_id"]}
      false -> false
    end
  end
end
