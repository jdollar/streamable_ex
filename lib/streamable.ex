defmodule Streamable do
  @moduledoc """
  Documentation for Streamable.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Streamable.hello
      :world

  """
  def hello do
    :world
  end

  def start, do: :application.ensure_all_started(:httppoison)

end
