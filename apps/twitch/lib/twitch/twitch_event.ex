defmodule Twitch.TwitchEvent do
  defstruct badges: nil,
            color: nil,
            emotes: nil,
            id: nil,
            room_id: nil,
            subscriber: nil,
            tmi_sent_ts: nil,
            turbo: nil,
            user_id: nil,
            username: nil,
            display_name: nil,
            message_type: nil,
            message: nil,
            channel: nil,
            irc_name: nil,
            irc_command: nil,
            raw_event: nil

  def parse(raw_message, channel) do
    case raw_message |> String.contains?("PRIVMSG") do
      true ->
        [meta, user | _rest] = raw_message |> String.split(":")

        # "@badges=subscriber/3,premium/1;color=;display-name=pokuna;emotes=;id=fb27b3b6-5fcd-4828-a65f-37852502ba4c;mod=0;room-id=26301881;subscriber=1;tmi-sent-ts=1536110195916;turbo=0;user-id=126692015;user-type= "
        meta_map = extract_meta(meta)

        # "pokuna!pokuna@pokuna.tmi.twitch.tv PRIVMSG #sodapoppin "
        [irc_name, command, channel] = user |> String.trim() |> String.split()

        user_map = %{
          "irc_name" => irc_name,
          "irc_command" => command,
          "channel" => channel
        }

        message = raw_message |> String.split("#{channel} :") |> Enum.at(-1) |> String.trim()
        message_map = %{"message" => message}

        as_map =
          %{"raw_event" => raw_message}
          |> Map.merge(meta_map)
          |> Map.merge(user_map)
          |> Map.merge(message_map)

        twitch_event = map_to_twitch_event(as_map)

        {:ok, twitch_event}

      false ->
        {:error, "Unknown message type"}
    end
  end

  def extract_meta(string) do
    parsed =
      string
      |> String.trim_leading("@")
      |> String.trim()
      |> String.split(";")
      |> Enum.map(&String.split(&1, "="))
      |> Enum.map(fn [a, b] -> {a |> String.replace("-", "_") |> Macro.underscore(), b} end)
      |> Map.new()

    # Convert badges from string to map
    {_changed, parsed} =
      Map.get_and_update(parsed, "badges", fn raw ->
        new_value =
          if String.length(raw) > 1 do
            raw
            |> String.split(",")
            |> Enum.map(&String.split(&1, "/"))
            |> Enum.map(fn [k, v] -> {k, v} end)
            |> Map.new()
          else
            %{}
          end

        {raw, new_value}
      end)

    parsed
  end

  def map_to_twitch_event(map) do
    parsed =
      map
      |> Map.take(~w(
          badges
          color
          emotes
          id
          room_id
          subscriber
          tmi_sent_ts
          turbo
          user_id
          display_name
          message
          channel
          irc_name
          irc_command
          raw_event
        ))
      |> Map.to_list()
      |> Enum.map(fn {a, b} -> {String.to_atom(a), b} end)
      |> Map.new()

    struct(Twitch.TwitchEvent, parsed)
  end
end
