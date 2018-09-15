defmodule Twitch.ChannelSubscriptionSupervisor do
  use DynamicSupervisor

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    resp = DynamicSupervisor.init(strategy: :one_for_one)

    # Resubscribe to disconnected channels
    Twitch.Channel
    |> Twitch.Repo.all()
    |> Twitch.Repo.preload(:user)
    |> Enum.each(fn channel ->
      spawn(fn ->
        Twitch.ChannelSubscriptionSupervisor.subscribe_to_channel(
          channel.name,
          channel.user
        )
      end)
    end)

    resp
  end

  def subscribe_to_channel(channel, twitch_user) do
    DynamicSupervisor.start_child(
      __MODULE__,
      {Twitch.ChannelSubscription, [channel, twitch_user]}
    )
  end
end
