defmodule ResponseParserText do
  use ExUnit.Case

  alias Streamable.ResponseParser
  alias Streamable.Error

  test "parse response error with valid body specifies body as reason" do
    assert {:error, %Error{reason: "test"}} == ResponseParser.parse_response({:error, "test"})
  end

  test "parse response error with invalid body returns nothing in response" do
    assert {:error, %Error{reason: ""}} == ResponseParser.parse_response({:invalid, "test"})
  end
end
