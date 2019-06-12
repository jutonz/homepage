defmodule Twitch.Queries.ChannelQuery do
  import Ecto.Query, only: [from: 2]

  def user_channels do
    from(ch in Twitch.Channel,
      join: u in assoc(ch, :user),
      preload: [user: u]
    )
  end

  def persist?(channel_name) do
    query =
      from(ch in Twitch.Channel,
        select: count(ch.id),
        where: ch.name == ^channel_name,
        where: ch.persist == true
      )

    Twitch.Repo.one(query) > 0
  end
end
