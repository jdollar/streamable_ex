defmodule Streamable.ResponseParser do
  alias Streamable.Error
  @moduledoc false

  def parse_response(response), do: parse_error(response)

  def parse_error({:error, responseBody}), do: {:error, %Error{reason: responseBody}}
  def parse_error(_), do: {:error, %Error{reason: ""}}
end
