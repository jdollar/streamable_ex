defmodule UploadTest do
  use ExUnit.Case, async: true
  alias Streamable.Upload
  alias Streamable.UploadResponse

  @success_response """
  {
    "status": 1,
    "shortcode": "test"
  }
  """

  setup_all do
    bypass = Bypass.open
    Application.put_env(:streamable, :base_url, "http://localhost:#{bypass.port}/")
    %{bypass: bypass}
  end

  describe "upload file" do
    test "successful upload returns upload response with poulated shortcode", %{bypass: bypass} do
      Bypass.expect_once bypass, "POST", "/upload", fn conn ->
        opts =
          []
          |> Keyword.put_new(:parsers, [Plug.Parsers.MULTIPART])
          |> Keyword.put_new(:json_decoder, Poison)

        conn = Plug.Parsers.call(conn, Plug.Parsers.init(opts))

        expected_filename = "mix.exs"
        expected_content_type ="application/octet-stream"

        %{"file" => %Plug.Upload{content_type: content_type, filename: filename}} = conn.body_params

        assert expected_filename == filename
        assert expected_content_type == content_type

        conn
        |> Plug.Conn.resp(200, @success_response)
        |> Plug.Conn.put_resp_header("Content-Type", "application/json")
      end

      expected_upload_response = %UploadResponse{
        status: 1,
        shortcode: "test"
      }

      assert {:ok, expected_upload_response} == Upload.upload("./mix.exs", "encodedAuthentication")
    end
  end
end
