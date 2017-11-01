defmodule Streamable.Videos do
  import Streamable.ResponseParser, only: [parse_response: 1]
  alias Streamable.Client
  @moduledoc false

  def videos(shortcode, authentication) do
    [
      Application.get_env(:streamable, :base_url),
      Application.get_env(:streamable, :videos_endpoint),
      "/",
      shortcode
    ]
    |> Enum.join
    |> Client.get(authentication)
    |> handle_videos_response
  end

  def oembed_video(url, authentication) do
    [
      Application.get_env(:streamable, :base_url),
      Application.get_env(:streamable, :videos_oembed_endpoint)
    ]
    |> Enum.join
    |> Client.get(authentication, %{"url" => url})
    |> handle_videos_oembed_response
  end

  defp handle_videos_response({:ok, responseBody}) do
    Poison.decode(responseBody, as: %Video{files: %{"mp4": %FileDetails{}, "mp4-mobile": %FileDetails{}}})
  end
  defp handle_videos_response(response), do: parse_response(response)

  defp handle_videos_oembed_response({:ok, responseBody}), do: Poison.decode(responseBody, as: %EmbedData{})
  defp handle_videos_oembed_response(response), do: parse_response(response)
end
