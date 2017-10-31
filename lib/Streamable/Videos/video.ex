defmodule Video do
  @moduledoc """

  Provides access to the streamable Videos api endpoints

  """
  @derive [Poison.Encoder]
  defstruct [:status, :title, :url, :embed_code, :source, :thumbnail_url, :message, :percent, :files]
end
