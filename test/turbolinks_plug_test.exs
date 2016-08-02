defmodule TurbolinksPlugTest do
  use ExUnit.Case
  use Plug.Test
  import Plug.Conn

  setup do
    session_opts = Plug.Session.init(
      store: :ets,
      key: "_test_session",
      table: :session
    )
    :ets.new(:session, [:named_table, :private, read_concurrency: true])

    conn = conn(:get, "/")
            |> Plug.Session.call(session_opts)
            |> fetch_session

    {:ok, conn: conn}
  end

  test "it stores redicted url in session", %{conn: conn} do
    url_in_session = conn
                      |> put_req_header("turbolinks-referrer", "http://example.com")
                      |> put_resp_header("location", "/new-url")
                      |> TurbolinksPlug.call(%{})
                      |> send_resp(302, "")
                      |> get_session("_turbolinks_location")

    assert url_in_session == "/new-url"
  end

  test "it sets turbolinks header if location present in session", %{conn: conn} do
    header = conn
              |> put_session("_turbolinks_location", "/redirected")
              |> TurbolinksPlug.call(%{})
              |> send_resp(200, "")
              |> get_resp_header("turbolinks-location")
              |> hd

    assert header == "/redirected"
  end
end
