defmodule Streamable do
  @moduledoc """
  Documentation for Streamable.
  """

  def start, do: :application.ensure_all_started(:httppoison, :poison)
end
