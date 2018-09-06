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

  def parse(raw_message) do
    parsed = raw_message |> :binary.bin_to_list() |> ExIrc.Utils.parse()

    case parsed.cmd do
      "PRIVMSG" ->
        [channel | message] = parsed.args

        {:ok,
         %Twitch.TwitchEvent{
           channel: channel,
           message: Enum.at(message, 0),
           irc_command: parsed.cmd,
           display_name: parsed.nick,
           raw_event: raw_message
         }}

      "PING" ->
        {:ok, %Twitch.TwitchEvent{irc_command: parsed.cmd}}

      _ ->
        {:error, "Unknown message type: #{parsed.cmd}"}
    end
  end

  def parse(raw_message) when is_binary(raw_message) do
    IO.inspect(raw_message)
  end
end
