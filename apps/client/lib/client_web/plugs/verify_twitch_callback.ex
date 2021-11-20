defmodule ClientWeb.Plugs.VerifyTwitchCallback do
  import Plug.Conn
  alias Twitch.Eventsub.Subscriptions

  def init(opts), do: opts

  @id_header "twitch-eventsub-message-id"
  @timestamp_header "twitch-eventsub-message-timestamp"
  @signature_header "twitch-eventsub-message-signature"
  def call(conn, _opts) do
    calc_sig = Subscriptions.calculate_signature(
      header(conn, @id_header)
      <> header(conn, @timestamp_header)
      <> raw_body(conn)
    )
    actual_sig = header(conn, @signature_header)

    if calc_sig == actual_sig do
      conn
    else
      conn
      |> send_resp(400, "")
      |> halt()
    end
  end

  def raw_body(conn) do
    case conn.assigns[:raw_body] do
      [body] -> body
      _ -> ""
    end
  end

  def header(conn, header) do
    case get_req_header(conn, header) do
      [val] -> val
      _ -> ""
    end
  end
end
