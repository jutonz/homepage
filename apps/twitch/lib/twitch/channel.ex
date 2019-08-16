defmodule Twitch.Channel do
  use Ecto.Schema
  alias Twitch.{Repo, Channel}
  import Ecto.Query, only: [from: 2]

  @type t :: %__MODULE__{}

  schema "channels" do
    field(:name, :string)
    field(:persist, :boolean)

    belongs_to(:user, Twitch.User)

    timestamps()
  end

  def changeset(%Channel{} = channel, attrs \\ %{}) do
    channel
    |> Ecto.Changeset.cast(attrs, ~w(name user_id persist)a)
    |> Ecto.Changeset.validate_required(~w(name user_id)a)
    |> Ecto.Changeset.unique_constraint(:name)
  end

  def subscribe(channel_name, twitch_user) do
    {:ok, channel} =
      %Channel{}
      |> Channel.changeset(%{
        name: channel_name,
        user_id: twitch_user.id
      })
      |> Repo.insert()

    Twitch.ChannelSubscriptionSupervisor.subscribe_to_channel(channel, twitch_user)

    {:ok, channel}
  end

  def unsubscribe(channel_name, twitch_user) do
    channel =
      Channel
      |> Repo.get_by(
        name: channel_name,
        user_id: twitch_user.id
      )

    if channel do
      Twitch.ChannelSubscriptionSupervisor.unsubscribe_from_channel(channel, twitch_user)
      Repo.delete(channel)
    end

    {:ok, channel}
  end

  def all_by_user_id(twitch_user_id) do
    channels =
      from(
        c in Twitch.Channel,
        where: c.user_id == ^twitch_user_id,
        limit: 100
      )
      |> Repo.all()

    {:ok, channels || []}
  end

  def get_by_user_id(twitch_user_id, channel_name) do
    channel =
      Twitch.Channel
      |> Twitch.Repo.get_by(
        user_id: twitch_user_id,
        name: "#" <> channel_name
      )

    case channel do
      %Twitch.Channel{} -> {:ok, channel}
      nil -> {:error, "No matching channel"}
    end
  end

  def with_irc_prefix(channel_name) do
    without_prefix = String.replace_leading(channel_name, "#", "")

    String.pad_leading(
      without_prefix,
      String.length(without_prefix) + 1,
      "#"
    )
  end

  def chat_process_name(channel_name) do
    :"TwitchChatSubscription:#{channel_name}"
  end

  def emote_watcher_name(channel_name) do
    :"Twitch.EmoteWatcher:#{channel_name}"
  end
end
