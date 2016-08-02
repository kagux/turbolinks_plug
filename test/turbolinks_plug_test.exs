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

  test "it stores redirected url in session", %{conn: conn} do
    url_in_session = conn
                      |> put_req_header("turbolinks-referrer", "http://example.com")
                      |> send_resp_with_location_header(status: 302, location: "/new-url")
                      |> get_session("_turbolinks_location")

    assert url_in_session == "/new-url"
  end

  test "it does not store redirected url if referrer is missing", %{conn: conn} do
    url_in_session = conn
                      |> send_resp_with_location_header(status: 302, location: "/new-url")
                      |> get_session("_turbolinks_location")

    refute url_in_session
  end

  test "it sets turbolinks header if location present in session", %{conn: conn} do
    header = conn
              |> send_resp_with_location_in_session(status: 200)
              |> get_resp_header("turbolinks-location")
              |> hd

    assert header == "/redirected"
  end

  test "it sets turbolinks header only for OK responsesl", %{conn: conn} do
    header = conn
              |> send_resp_with_location_in_session(status: 404)
              |> get_resp_header("turbolinks-location")

    assert header == []
  end

  test "it removes turbolinks location from session after setting header", %{conn: conn} do
    url_in_session = conn
                      |> send_resp_with_location_in_session(status: 200)
                      |> get_session("_turbolinks_location")

    refute url_in_session
  end

  defp send_resp_with_location_in_session(conn, opts) do
    conn
    |> put_session("_turbolinks_location", "/redirected")
    |> send_resp_with_turbolinks(opts)
  end

  defp send_resp_with_location_header(conn, opts) do
    conn
    |> put_resp_header("location", opts[:location])
    |> send_resp_with_turbolinks(opts)
  end

  defp send_resp_with_turbolinks(conn, opts) do
    conn
    |> TurbolinksPlug.call(%{})
    |> send_resp(opts[:status], "")
  end
end
