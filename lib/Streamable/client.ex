defmodule Streamable.Client do
  @moduledoc false

  def get(url, authenticationEncoded, params \\ %{})
  def get(url, {username, password}, params), do: get(url, generateAuthenticationEncoded(username, password), params)
  def get(url, authenticationEncoded, params) do
    header = [{"Authorization", "Basic #{authenticationEncoded}"}]
    param_value = if Enum.empty?(params), do: "", else: "?" <> URI.encode_query(params)

    url <> param_value
    |> HTTPoison.get(header)
    |> handle_response
  end

  def post(url, body, {username, password}), do: post(url, body, generateAuthenticationEncoded(username, password))
  def post(url, body, authenticationEncoded) do
    header = [{"Authorization", "Basic #{authenticationEncoded}"}]
    url |> HTTPoison.post(body, header) |> handle_response
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}), do: {:error, reason}
  defp handle_response({:ok, %HTTPoison.Response{headers: headers, body: body}}) do
    {_, value} = Enum.find(headers, fn({key, _}) -> "content-type" == String.downcase(key) end)
    [value | _] = String.split(value, [";"])

    case value do
      "text/html" -> {:error, body}
      "application/json" -> {:ok, body}
    end
  end

  defp generateAuthenticationEncoded(username, password), do: Base.encode64("#{username}:#{password}")
end
