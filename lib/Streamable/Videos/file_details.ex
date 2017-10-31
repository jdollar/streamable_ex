defmodule FileDetails do
  @moduledoc false
  
  @derive [Poison.Encoder]
  defstruct [:status, :url, :width, :height, :bitrate, :duration, :size, :framerate]
end
