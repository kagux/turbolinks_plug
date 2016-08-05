defmodule TurbolinksPlug do
  import Plug.Conn

  @session_key "_turbolinks_location"
  @location_header "turbolinks-location"
  @referrer_header "turbolinks-referrer"

  def init(opts), do: opts

  def call(conn, _) do
    register_before_send(conn, &handle_redirect/1)
  end

  def handle_redirect(%Plug.Conn{status: s} = conn) when s == 301 or s == 302 do
    location = get_resp_header(conn, "location") |> hd
    referrer = get_req_header(conn, @referrer_header)
    store_location_in_session(conn, location, referrer)
  end

  def handle_redirect(%Plug.Conn{status: s} = conn) when s >= 200 and s < 300  do
    conn
     |> get_session(@session_key)
     |> set_location_header(conn)
  end

  def handle_redirect(conn), do: conn

  defp store_location_in_session(conn, _location, []), do: conn

  defp store_location_in_session(conn, location, _referrer) do
    put_session(conn, @session_key, location)
  end

  defp set_location_header(nil, conn), do: conn

  defp set_location_header(location, conn) do
    conn 
      |> put_resp_header(@location_header, location) 
      |> delete_session(@session_key)
  end
end
