defmodule VideosTest do
  use ExUnit.Case
  alias Streamable.Videos
  alias EmbedData

  @oembed_success_response """
  {
    "provider_url": "test.com",
    "html": "<h1>Hi</h1>",
    "version": "1.0",
    "title": "Title",
    "type": "Type",
    "provider_name": "Provider Name",
    "thumbnail_url": "thumbnail.com",
    "width": "100",
    "height": "50"
  }
  """

  @videos_success_response """
  {
    "status": 2,
    "files": {
      "mp4": {
        "status": 2,
        "width": 480,
        "url": "//cdn-w2.streamable.com/video/f6441ae0c84311e4af010bc47400a0a4.mp4?token=1510968575_9a9977e880a2b07e7e9f118928076fde980e11b9",
        "bitrate": 0,
        "duration": 0,
        "size": 0,
        "framerate": 0,
        "height": 480
      }
    },
    "embed_code": "<div>test</div>",
    "source": null,
    "thumbnail_url": "//images.streamable.com/west/image/f6441ae0c84311e4af010bc47400a0a4.jpg?height=100",
    "url": "streamable.com/moo",
    "title": "Please don't eat me!",
    "message": null,
    "percent": 100
  }
  """

  setup do
    bypass = Bypass.open

    Application.put_env(:streamable, :base_url, "http://localhost:#{bypass.port}/")
    %{bypass: bypass}
  end

  describe "videos" do
    test "success response returns video data", %{bypass: bypass} do
      shortcode = "test"
      path = "/" <> Application.get_env(:streamable, :videos_endpoint) <> "/" <> shortcode
      Bypass.expect_once bypass, "GET", path, fn conn ->
        conn
        |> Plug.Conn.resp(200, @videos_success_response)
        |> Plug.Conn.put_resp_header("Content-Type", "application/json")
      end

      expected_video_details = %Video{
        status: 2,
        files: %{
          "mp4" => %{
            "status" => 2,
            "width" => 480,
            "url" => "//cdn-w2.streamable.com/video/f6441ae0c84311e4af010bc47400a0a4.mp4?token=1510968575_9a9977e880a2b07e7e9f118928076fde980e11b9",
            "bitrate" => 0,
            "duration" => 0,
            "size" => 0,
            "framerate" => 0,
            "height" => 480
          }
        },
        embed_code: "<div>test</div>",
        source: nil,
        thumbnail_url: "//images.streamable.com/west/image/f6441ae0c84311e4af010bc47400a0a4.jpg?height=100",
        url: "streamable.com/moo",
        message: nil,
        title: "Please don't eat me!",
        percent: 100
      }

      assert {:ok, expected_video_details} == Videos.videos(shortcode, "encodedAuthentication")
    end
  end

  describe "oembed_video" do
    test "success response returns embed data", %{bypass: bypass} do
      url = "http://test.com"

      Bypass.expect_once bypass, "GET", "/oembed.json", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert %{"url" => url} == conn.query_params

        conn
        |> Plug.Conn.resp(200, @oembed_success_response)
        |> Plug.Conn.put_resp_header("Content-Type", "application/json")
      end

      expected_embed_data = %EmbedData{
        provider_url: "test.com",
        html: "<h1>Hi</h1>",
        version: "1.0",
        title: "Title",
        type: "Type",
        provider_name: "Provider Name",
        thumbnail_url: "thumbnail.com",
        width: "100",
        height: "50"
      }

      assert {:ok, expected_embed_data} == Videos.oembed_video(url, "encodedAuthentication")
    end
  end
end
