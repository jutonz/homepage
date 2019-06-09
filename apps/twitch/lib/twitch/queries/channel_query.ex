defmodule Twitch.Queries.ChannelQuery do
  import Ecto.Query, only: [from: 2]

  def user_channels do
    from(ch in Twitch.Channel,
      join: u in assoc(ch, :user),
      preload: [user: u]
    )
  end
end
