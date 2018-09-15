defmodule Twitch.Channel do
  use Ecto.Schema
  alias Twitch.{Repo, Channel}
  import Ecto.Query, only: [from: 2]

  @type t :: %__MODULE__{}

  schema "channels" do
    field(:name, :string)

    belongs_to(:user, Twitch.User)

    timestamps()
  end

  def changeset(%Channel{} = channel, attrs \\ %{}) do
    channel
    |> Ecto.Changeset.cast(attrs, ~w(name user_id)a)
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

    process_name = Twitch.Channel.process_name(channel_name, twitch_user)

    DynamicSupervisor.start_child(
      Twitch.ChannelSubscriptionSupervisor,
      {Twitch.ChannelSubscription, [channel_name, twitch_user, process_name]}
    )

    {:ok, channel}
  end

  def unsubscribe(channel_name, twitch_user) do
    channel = Channel |> Repo.get_by(name: channel_name, user_id: twitch_user.id)

    if channel do
      channel |> Repo.delete()
    end

    process_name = Twitch.Channel.process_name(channel_name, twitch_user)
    IO.puts(process_name)

    case Process.whereis(process_name) do
      pid when is_pid(pid) ->
        Twitch.ChannelSubscriptionSupervisor |> DynamicSupervisor.terminate_child(pid)

      _ ->
        {:ok, "Not subscribed"}
    end

    {:ok, channel}
  end

  def get_by_user_id(twitch_user_id) do
    channels =
      from(
        c in Twitch.Channel,
        where: c.user_id == ^twitch_user_id,
        limit: 100
      )
      |> Repo.all()

    {:ok, channels || []}
  end

  def process_name(channel_name, twitch_user) do
    :"TwitchChannelSubscription:#{channel_name}:#{twitch_user.twitch_user_id}"
  end
end
