defmodule Twitch.Eventsub.ChannelUpdates do
  import Ecto.Query, only: [from: 2, order_by: 2]

  alias Twitch.{
    Eventsub.ChannelUpdates.Update,
    Repo
  }

  def list_by_user_id(user_id) do
    query = from(u in Update, where: u.twitch_user_id == ^user_id)

    query
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def create(attrs) do
    %Update{}
    |> Update.changeset(attrs)
    |> Repo.insert()
  end
end
