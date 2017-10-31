defmodule EmbedData do
  @moduledoc false
  @derive [Poison.Encoder]
  defstruct [:provider_url, :html, :version, :title, :type, :provider_name, :thumbnail_url, :width, :height]
end
