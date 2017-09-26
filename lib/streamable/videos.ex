defmodule Streamable.Videos do
  alias Streamable.Client, as: Client

  @moduledoc """
  Provides access to the streamable Videos api endpoints
  """

  @doc """
  Hello world.
  """
  defmodule Video do
    @moduledoc """

    Provides access to the streamable Videos api endpoints

    """
    @derive [Poison.Encoder]
    defstruct [:status, :title, :url, :embed_code, :source, :thumbnail_url, :message, :percent, :files]
  end

  defmodule EmbedData do
    @derive [Poison.Encoder]
    defstruct [:provider_url, :html, :version, :title, :type, :provider_name, :thumbnail_url, :width, :height]
  end

  defmodule VideoError do
    @moduledoc """

    Provides access to the streamable Videos api endpoints

    """
    defstruct [:reason]
  end

  defmodule FileDetails do
    @derive [Poison.Encoder]
    defstruct [:status, :url, :width, :height, :bitrate, :duration, :size, :framerate]
  end

  def videos(shortcode, authentication) do
    Application.get_env(:streamable, :base_url) <> Application.get_env(:streamable, :videos_endpoint) <> "/" <> shortcode
    |> Client.get(authentication)
    |> handle_videos_response
  end

  def oembed_video(url, authentication) do
      Application.get_env(:streamable, :base_url) <> Application.get_env(:streamable, :videos_oembed_endpoint)
      |> Client.get(authentication, %{"url" => url})
      |> handle_videos_oembed_response
  end

  defp handle_videos_response(response) do
    case response do
      {:ok, responseBody} ->
        Poison.decode(responseBody, as: %Video{files: %{"mp4": %FileDetails{}, "mp4-mobile": %FileDetails{}}})
      _ ->
        handle_error_response response
    end
  end

  defp handle_videos_oembed_response(response) do
    case response do
      {:ok, responseBody} ->
        Poison.decode(responseBody, as: %EmbedData{})
      _ ->
        handle_error_response response
    end
  end

  defp handle_error_response(response) do
    case response do
      {:error, responseBody} ->
        {:error, %VideoError{reason: responseBody}}
      _ ->
        {:error, %VideoError{reason: ""}}
    end
  end
end
