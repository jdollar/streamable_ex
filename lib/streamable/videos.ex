defmodule Streamable.Videos do
  alias Streamable.Client, as: Client

  @moduledoc """
  Documentation for Streamable.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Streamable.hello
      :world

  """
  def videos(shortcode, authentication) do
    url = Application.get_env(:streamable, :base_url) <> Application.get_env(:streamable, :videos_endpoint) <> "/" <> shortcode
    Client.get(url, authentication)
  end
end

