defmodule Streamable.Client do
  def get(url, authenticationEncoded, params \\ %{})
  def get(url, {username, password}, params), do: get(url, generateAuthenticationEncoded(username, password), params)
  def get(url, authenticationEncoded, params) do
    header = [{"Authentication", "Basic #{authenticationEncoded}"}]
    paramValue = if (!Enum.empty?(params)), do: "?" <> URI.encode_query(params), else: ""

    url <> paramValue
    |> HTTPoison.get(header)
    |> handle_response
  end

  def post(url, body, {username, password}), do: post(url, body, generateAuthenticationEncoded(username, password))
  def post(url, body, authenticationEncoded) do
    header = [{"Authentication", "Basic #{authenticationEncoded}"}]
    HTTPoison.post(url, body, header) |> handle_response
  end

  defp generateAuthenticationEncoded(username, password), do: Base.encode64("#{username}:#{password}")

  defp handle_response({:ok, %HTTPoison.Response{headers: headers, body: body}}) do
    {_, value} = Enum.find(headers, fn({key, _}) -> "Content-Type" == key end)
    [value | _ ] = String.split(value, [";"])

    case value do
      "text/html" -> {:error, body}
      "application/json" -> {:ok, body}
    end
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}), do: {:error, reason}
  defp handle_response(_), do: {:error, ""}

end
