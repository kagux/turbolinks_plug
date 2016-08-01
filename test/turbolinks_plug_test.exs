defmodule TurbolinksPlugTest do
  use ExUnit.Case
  use Plug.Test
  import Plug.Conn

  test "it stores redicted url in session" do
    session = Plug.Session.init(
      store: :ets,
      key: "_test_session",
      table: :session
    )
    :ets.new(:session, [:named_table, :public, read_concurrency: true])
    url_in_session =  conn(:get, "/")
                      |> Plug.Session.call(session)
                      |> fetch_session
                      |> put_req_header("turbolinks-referrer", "http://example.com")
                      |> put_resp_header("location", "/new-url")
                      |> TurbolinksPlug.call(%{})
                      |> send_resp(302, "")
                      |> get_session("_turbolinks_location")
                      |> hd

    assert url_in_session == "/new-url"
  end
end
