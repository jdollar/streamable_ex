defmodule Streamable.Client do
  def get(url, {username, password}) do
    get(url, Base.encode64("#{username}:#{password}"))
  end

  def get(url, authenticationEncoded) do
    header = [{"Authentication", "Basic #{authenticationEncoded}"}]
    HTTPoison.get(url, header) |> handle_response
  end

  defp handle_response({:ok, %HTTPoison.Response{headers: headers, body: body}}) do
    {key, value} = Enum.find(headers, fn({key, _}) -> "Content-Type" == key end)
    [value | _ ] = String.split(value, [";"])
    
    case value do
      "text/html" -> IO.inspect body
      "application/json" -> IO.inspect body
    end
    
    #Success
    
    #Error
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}), do: IO.inspect reason

end

