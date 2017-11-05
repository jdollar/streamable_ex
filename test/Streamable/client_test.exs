defmodule ClientTest do
  use ExUnit.Case, async: true
  alias Streamable.Client

  setup do
    bypass = Bypass.open
    %{bypass: bypass, url: "http://localhost:#{bypass.port}/"}
  end

  describe "get/3 encoded authentication" do
    setup context do
      Map.put(context, :auth, "encodedAuthentication")
    end

    test "Success response with text/html returns error", %{bypass: bypass, url: url, auth: auth} do
      Bypass.expect_once bypass, "GET", "/", fn conn ->
        setupRequestExpectation(conn, 200, "test", auth, "text/html")
      end
      assert {:error, "test"} == Client.get(url, auth)
    end

    test "Success response with application/json returns good response", %{bypass: bypass, url: url, auth: auth} do
      Bypass.expect_once bypass, "GET", "/", fn conn ->
        setupRequestExpectation(conn, 200, "test", auth, "application/json")
      end
      assert {:ok, "test"} == Client.get(url, auth)
    end

    test "Error response returns error and reason", %{bypass: bypass, url: url} do
      Bypass.down(bypass)
      assert {:error, :econnrefused} == Client.get(url, "encodedAuthentication")
    end
  end

  describe "get/3 authentication tuple" do
    setup context do
      Map.put(context, :auth, {"username", "password"})
    end

    test "Success response with text/html returns error", %{bypass: bypass, url: url, auth: auth} do
      Bypass.expect_once bypass, "GET", "/", fn conn ->
        setupRequestExpectation(conn, 200, "test", auth, "text/html")
      end
      assert {:error, "test"} == Client.get(url, auth)
    end

    test "Success response with application/json returns good response", %{bypass: bypass, url: url, auth: auth} do
      Bypass.expect_once bypass, "GET", "/", fn conn ->
        setupRequestExpectation(conn, 200, "test", auth, "application/json")
      end
      assert {:ok, "test"} == Client.get(url, auth)
    end

    test "Error response returns error and reason", %{bypass: bypass, url: url} do
      Bypass.down(bypass)
      assert {:error, :econnrefused} == Client.get(url, "encodedAuthentication")
    end
  end

  describe "post/3 authentication encoded" do
    setup context do
      context
      |> Map.put(:auth, "encodedAuthentication")
      |> Map.put(:body, "{\"test\": \"test\"}")
    end

    test "Success response with text/html returns error", %{bypass: bypass, url: url, auth: auth, body: body} do
      Bypass.expect_once bypass, "POST", "/", fn conn ->
        setupRequestExpectation(conn, 200, body, auth, "text/html")
      end
      assert {:error, body} == Client.post(url, body, auth)
    end

    test "Success response with application/json returns good response", %{bypass: bypass, url: url, auth: auth, body: body} do
      Bypass.expect_once bypass, "POST", "/", fn conn ->
        setupRequestExpectation(conn, 200, body, auth, "application/json")
      end
      assert {:ok, body} == Client.post(url, body, auth)
    end

    test "Error response returns error and reason", %{bypass: bypass, url: url, auth: auth, body: body} do
      Bypass.down(bypass)
      assert {:error, :econnrefused} == Client.post(url, body, auth)
    end
  end

  describe "post/3 authentication tuple" do
    setup context do
      context
      |> Map.put(:auth, {"username", "password"})
      |> Map.put(:body, "{\"test\": \"test\"}")
    end

    test "Success response with text/html returns error", %{bypass: bypass, url: url, auth: auth, body: body} do
      Bypass.expect_once bypass, "POST", "/", fn conn ->
        setupRequestExpectation(conn, 200, body, auth, "text/html")
      end
      assert {:error, body} == Client.post(url, body, auth)
    end

    test "Success response with application/json returns good response", %{bypass: bypass, url: url, auth: auth, body: body} do
      Bypass.expect_once bypass, "POST", "/", fn conn ->
        setupRequestExpectation(conn, 200, body, auth, "application/json")
      end
      assert {:ok, body} == Client.post(url, body, auth)
    end

    test "Error response returns error and reason", %{bypass: bypass, url: url, auth: auth, body: body} do
      Bypass.down(bypass)
      assert {:error, :econnrefused} == Client.post(url, body, auth)
    end
  end

  defp setupRequestExpectation(conn, status_code, body, auth, content_type) do
    validateAuthentication(conn.req_headers, auth)

    conn
    |> Plug.Conn.resp(status_code, body)
    |> Plug.Conn.put_resp_header("Content-Type", content_type)
  end

  defp validateAuthentication(headers, {username, password}) do
    validateAuthentication(headers, Base.encode64(username <> ":" <> password))
  end

  defp validateAuthentication(headers, expected) do
    {_, value} = Enum.find(headers, fn {key, _} -> "authorization" == key end)
    assert value == "Basic " <> expected
  end
end
