defmodule Evented.Twitch do
  @client_id "ja9ef15nl8k4wrvne24e9q1zzqnl7b"
  @client_secret "5ln8xb4ldmwcvzglgosh4e8q0oc1s4"
  @scope "chat:read chat:edit channel:moderate"
  # @scope "chat_login"

  defmodule TwitchEvent do
    defstruct badges: nil,
              color: nil,
              emotes: nil,
              id: nil,
              room_id: nil,
              subscriber: nil,
              tmi_sent_ts: nil,
              turbo: nil,
              user_id: nil,
              user_type: nil,
              emotes_raw: nil,
              badges_raw: nil,
              username: nil,
              display_name: nil,
              message_type: nil,
              message: nil
  end

  def get_token() do
    params = %{
      client_id: @client_id,
      client_secret: @client_secret,
      grant_type: "client_credentials",
      scope: @scope
    }

    headers = [
      {"Accept", "application/json"}
    ]

    response =
      HTTPoison.post(
        "https://id.twitch.tv/oauth2/token",
        # "https://api.twitch.tv/kraken/oauth2/token",
        "",
        headers,
        params: params,
        follow_redirect: true
      )

    IO.inspect(response)

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, decoded} = body |> Poison.decode()
        # TODO: Also confirm scope?
        {:ok, decoded["access_token"]}

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {:error, "#{status_code}: #{body}"}

      _ ->
        {:error, "nope"}
    end
  end

  def authorize_url() do
    params =
      %{
        client_id: @client_id,
        redirect_uri: "http://localhost:4000/twitch/oauth",
        response_type: "code",
        scope: @scope
      }
      |> URI.encode_query()

    uri = "https://id.twitch.tv/oauth2/authorize?#{params}"
    {:ok, uri}
  end

  def exchange(code) do
    params = %{
      client_id: @client_id,
      client_secret: @client_secret,
      redirect_uri: "http://localhost:4000/twitch/oauth",
      grant_type: "authorization_code",
      code: code,
      scope: @scope
    }

    headers = [
      {"Accept", "application/json"}
    ]

    response =
      HTTPoison.post(
        "https://id.twitch.tv/oauth2/token",
        "",
        headers,
        params: params,
        follow_redirect: true
      )

    IO.inspect(response)

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, decoded} = body |> Poison.decode()
        # TODO: Also confirm scope?
        {:ok, decoded["access_token"]}

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {:error, "#{status_code}: #{body}"}

      _ ->
        {:error, "nope"}
    end
  end

  def parse(raw_message, channel) do
    IO.inspect(raw_message)

    case raw_message |> String.contains?("PRIVMSG") do
      true ->
        as_map =
          raw_message
          |> String.trim_leading("@")
          |> String.split(";")
          |> Enum.map(&String.split(&1, "="))
          |> Enum.map(fn [a, b] -> {a |> String.replace("-", "_") |> Macro.underscore(), b} end)
          |> Map.new()

        # Need to cleanup message a bit as it includes some IRC gibberish
        user_type = as_map["user_type"]

        as_map =
          if user_type do
            message =
              user_type |> String.split("PRIVMSG #{channel} :") |> Enum.at(1) |> String.trim()

            as_map |> Map.put("message", message)
          else
            as_map
          end

        twitch_event = map_to_twitch_event(as_map)

        {:ok, twitch_event}

      false ->
        {:error, "Unknown message type"}
    end
  end

  def map_to_twitch_event(map) do
    parsed =
      map
      |> Map.take(
        ~w(badges color emotes id room_id subscriber tmi_sent_ts turbo user_id user_type username display_name message message_type user_type)
      )
      |> Map.to_list()
      |> Enum.map(fn {a, b} -> {String.to_atom(a), b} end)
      |> Map.new()

    parsed =
      Map.get_and_update(parsed, :badges, fn raw ->
        new_value =
          raw
          |> String.split(",")
          |> Enum.map(&String.split(&1, "/"))
          |> Enum.map(fn [k, v] -> {k, v} end)
          |> Map.new()

        {raw, new_value}
      end)

    parsed
  end
end
