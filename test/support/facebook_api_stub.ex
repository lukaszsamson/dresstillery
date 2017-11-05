defmodule Dresstillery.FacebookApiStub do
  def is_valid("valid_token"), do: {true, "12345"}
  def is_valid("api_down"), do: :error
  def is_valid(_), do: false
end
