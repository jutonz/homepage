defmodule Twitch.ParsedEvent do
  @derive Jason.Encoder
  defstruct emotes: [],
            id: nil,
            user_id: nil,
            display_name: nil,
            message_type: nil,
            message: nil,
            channel: nil,
            irc_command: nil,
            raw_event: nil,
            tags: nil

  @type t :: %__MODULE__{
          emotes: list(Twitch.Emote),
          id: String.t() | nil,
          user_id: String.t() | nil,
          display_name: String.t() | nil,
          message_type: String.t() | nil,
          message: String.t() | nil,
          channel: String.t() | nil,
          irc_command: String.t() | nil,
          raw_event: String.t() | nil,
          tags: map
        }

  def from_raw(raw_message) do
    {tags, raw_message} = maybe_extract_tags(raw_message)
    parsed = raw_message |> :binary.bin_to_list() |> ExIRC.Utils.parse()
    raw = raw_message |> :binary.bin_to_list() |> to_string()
    to_parsed_event(parsed.cmd, parsed, raw, tags)
  end

  @tag_regex ~r/(?<tags>^@.*?\s)/
  def maybe_extract_tags(raw_message) do
    case Regex.named_captures(@tag_regex, raw_message) do
      nil ->
        {nil, raw_message}

      match ->
        tags = Map.get(match, "tags")
        raw_without_tags = String.trim_leading(raw_message, tags)

        {tags, raw_without_tags}
    end
  end

  def parse_tags(nil), do: %{}

  def parse_tags(tags) do
    tags
    |> String.trim_leading("@")
    |> String.split(";")
    |> Enum.map(&String.split(&1, "="))
    |> Enum.into(%{}, fn [key, value] -> {key, value} end)
  end

  def to_parsed_event("PRIVMSG", parsed, raw, tags) do
    [channel | message] = parsed.args
    parsed_tags = parse_tags(tags)

    parsed_event = %__MODULE__{
      channel: channel,
      display_name: parsed.nick,
      id: parsed_tags["id"],
      irc_command: parsed.cmd,
      message: Enum.at(message, 0),
      raw_event: raw,
      tags: parsed_tags
    }

    twitch_emotes = Twitch.EmoteWatcher.TwitchEmoteExtractor.extract(parsed_event)
    parsed_event = Map.put(parsed_event, :emotes, twitch_emotes)

    {:ok, parsed_event}
  end

  def to_parsed_event("ACTION", parsed, raw, _tags) do
    [channel | message] = parsed.args

    {:ok,
     %Twitch.ParsedEvent{
       channel: channel,
       message: Enum.at(message, 0),
       irc_command: "ACTION",
       display_name: parsed.nick,
       raw_event: raw
     }}
  end

  def to_parsed_event("CLEARCHAT", parsed, raw, _tags) do
    [channel | user] = parsed.args

    {:ok,
     %Twitch.ParsedEvent{
       channel: channel,
       message: hd(user),
       irc_command: parsed.cmd,
       raw_event: raw
     }}
  end

  def to_parsed_event("HOSTTARGET", parsed, raw, _tags) do
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

  def to_parsed_event("JOIN", parsed, raw, _tags) do
    [channel | _rest] = parsed.args

    {:ok,
     %Twitch.ParsedEvent{
       channel: channel,
       irc_command: parsed.cmd,
       display_name: parsed.nick,
       raw_event: raw
     }}
  end

  def to_parsed_event("PART", parsed, raw, _tags) do
    [channel | _rest] = parsed.args

    {:ok,
     %Twitch.ParsedEvent{
       channel: channel,
       irc_command: parsed.cmd,
       display_name: parsed.nick,
       raw_event: raw
     }}
  end

  def to_parsed_event("USERNOTICE", parsed, raw, _tags) do
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

  def to_parsed_event("PING", parsed, _raw, _tags) do
    {:ok, %Twitch.ParsedEvent{irc_command: parsed.cmd}}
  end

  def to_parsed_event("MODE", parsed, raw, _tags) do
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
  def to_parsed_event("353", parsed, raw, _tags) do
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

  def to_parsed_event("GLOBALUSERSTATE", parsed, raw, _tags) do
    {:ok, %Twitch.ParsedEvent{irc_command: parsed.cmd, raw_event: raw}}
  end

  def to_parsed_event("CAP", parsed, raw, _tags) do
    # parsed.args looks like ["*", "ACK", "cap1 cap2 cap3"]

    {:ok,
     %Twitch.ParsedEvent{
       irc_command: parsed.cmd,
       raw_event: raw,
       message: Enum.at(parsed.args, 2)
     }}
  end

  def to_parsed_event(command, _parsed, _raw, _tags) do
    {:error, "Unknown message type: #{command}"}
  end
end
