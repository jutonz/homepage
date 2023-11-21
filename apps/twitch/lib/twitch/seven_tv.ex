defmodule Twitch.SevenTv do
  alias Twitch.SevenTv

  def channel_emotes(channel_name) do
    :get
    |> client().connection("/v3/users/twitch/#{channel_name}")
    |> get_in(~w(emote_set emotes))
    |> Kernel.||([])
    |> Enum.map(&SevenTv.Emote.from_json/1)
  end

  def client, do: Application.get_env(:twitch, :seven_tv_api_client)
end
