defmodule Twitch.ParsedEvent do
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

  def from_raw(raw_message) do
    parsed = raw_message |> :binary.bin_to_list() |> ExIRC.Utils.parse()
    raw = raw_message |> :binary.bin_to_list() |> to_string()
    to_parsed_event(parsed.cmd, parsed, raw)
  end

  def to_parsed_event("PRIVMSG", parsed, raw) do
    [channel | message] = parsed.args

    {:ok,
     %Twitch.ParsedEvent{
       channel: channel,
       message: Enum.at(message, 0),
       irc_command: parsed.cmd,
       display_name: parsed.nick,
       raw_event: raw
     }}
  end

  def to_parsed_event("CLEARCHAT", parsed, raw) do
    [channel | user] = parsed.args

    {:ok,
     %Twitch.ParsedEvent{
       channel: channel,
       message: hd(user),
       irc_command: parsed.cmd,
       raw_event: raw
     }}
  end

  def to_parsed_event("HOSTTARGET", parsed, raw) do
    [channel | target_channel] = parsed.args

    target_channel = target_channel |> Enum.at(0) |> String.trim_trailing(" -")

    {:ok,
     %Twitch.ParsedEvent{
       channel: channel,
       message: target_channel,
       irc_command: parsed.cmd,
       raw_event: raw
     }}
  end

  def to_parsed_event("JOIN", parsed, raw) do
    [channel | _rest] = parsed.args

    {:ok,
     %Twitch.ParsedEvent{
       channel: channel,
       irc_command: parsed.cmd,
       display_name: parsed.nick,
       raw_event: raw
     }}
  end

  def to_parsed_event("PART", parsed, raw) do
    [channel | _rest] = parsed.args

    {:ok,
     %Twitch.ParsedEvent{
       channel: channel,
       irc_command: parsed.cmd,
       display_name: parsed.nick,
       raw_event: raw
     }}
  end

  def to_parsed_event("USERNOTICE", parsed, raw) do
    [channel | message] = parsed.args

    {:ok,
     %Twitch.ParsedEvent{
       channel: channel,
       message: Enum.at(message, 0),
       irc_command: parsed.cmd,
       display_name: parsed.nick,
       raw_event: raw
     }}
  end

  def to_parsed_event("PING", parsed, _raw) do
    {:ok, %Twitch.ParsedEvent{irc_command: parsed.cmd}}
  end

  def to_parsed_event("MODE", parsed, raw) do
    [channel | rest] = parsed.args

    # rest is an array like ["-o", "syps_"]
    message = rest |> Enum.join(" ")

    {:ok,
     %Twitch.ParsedEvent{
       channel: channel,
       message: message,
       irc_command: parsed.cmd,
       display_name: parsed.nick,
       raw_event: raw
     }}
  end

  # NAMES list
  def to_parsed_event("353", parsed, raw) do
    [display_name | [_ | [channel | rest]]] = parsed.args

    # rest is an array of a string of the users who joined, e,g.
    # ["user1 user2 user3"]
    message = rest |> Enum.at(0)

    {:ok,
     %Twitch.ParsedEvent{
       channel: channel,
       message: message,
       irc_command: parsed.cmd,
       display_name: display_name,
       raw_event: raw
     }}
  end

  def to_parsed_event("GLOBALUSERSTATE", parsed, raw) do
    {:ok, %Twitch.ParsedEvent{irc_command: parsed.cmd, raw_event: raw}}
  end

  def to_parsed_event("CAP", parsed, raw) do
    # parsed.args looks like ["*", "ACK", "cap1 cap2 cap3"]

    {:ok,
     %Twitch.ParsedEvent{
       irc_command: parsed.cmd,
       raw_event: raw,
       message: Enum.at(parsed.args, 2)
     }}
  end

  def to_parsed_event(command, _parsed, _raw) do
    {:error, "Unknown message type: #{command}"}
  end
end
