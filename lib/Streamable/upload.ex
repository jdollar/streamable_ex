defmodule Streamable.Upload do
  import Streamable.ResponseParser, only: [parse_response: 1]
  alias Streamable.Client
  alias Streamable.UploadResponse
  @moduledoc false

  @spec upload(String.t, {String.t, String.t}) :: {atom, Map.t}
  def upload(videoPath, authentication) do
    Application.get_env(:streamable, :base_url) <> Application.get_env(:streamable, :upload_endpoint)
    |> Client.post({:multipart, [{:file, videoPath}]}, authentication)
    |> handle_response
  end

  @spec handle_response({atom, Map.t}) :: {atom, Upload.t}
  defp handle_response({:ok, responseBody}) do
    Poison.decode(responseBody, as: %UploadResponse{})
  end

  @spec handle_response(any) :: any
  defp handle_response(response), do: parse_response(response)
end
