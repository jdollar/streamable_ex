defmodule Streamable.Upload do
  import Streamable.ResponseParser, only: [parse_response: 1]
  alias Streamable.Client
  @moduledoc false

  @spec videos(String.t, {String.t, String.t}) :: {atom, Map.t}
  def videos(shortcode, authentication) do
    Application.get_env(:streamable, :base_url) <> Application.get_env(:streamable, :upload_endpoint)
    |> Client.post([], authentication)
    |> handle_response
  end

  @spec handle_response({atom, Map.t}) :: {atom, Upload.t}
  defp handle_response({:ok, responseBody}) do
    Poison.decode(responseBody, as: %Video{files: %{"mp4": %FileDetails{}, "mp4-mobile": %FileDetails{}}})
  end

  @spec handle_response(any) :: any
  defp handle_response(response), do: parse_response(response)
end
