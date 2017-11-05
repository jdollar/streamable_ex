defmodule Streamable.UploadResponse do
  @moduledoc """

  Response struct for the response returned by the upload endpoint

  """
  @derive [Poison.Encoder]
  defstruct [:status, :shortcode]
end
