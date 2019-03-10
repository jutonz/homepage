defmodule Twitch.ChannelSubscriptionSupervisor do
  use DynamicSupervisor
  require Logger

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    # Resubscribe to disconnected channels
    spawn(fn ->
      :timer.sleep(5000)

      Twitch.Channel
      |> Twitch.Repo.all()
      |> Twitch.Repo.preload(:user)
      |> Enum.each(fn channel ->
        Twitch.ChannelSubscriptionSupervisor.subscribe_to_channel(
          channel,
          channel.user
        )
      end)
    end)

    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def subscribe_to_channel(channel, twitch_user) do
    process_name = Twitch.Channel.process_name(channel.name, twitch_user)

    res =
      DynamicSupervisor.start_child(
        __MODULE__,
        {Twitch.ChannelSubscription, [channel.name, twitch_user.id, process_name]}
      )

    Logger.info(
      "Starting twitch channel subscription for channel #{channel.name}: #{inspect(res)}"
    )

    DynamicSupervisor.start_child(
      __MODULE__,
      {Twitch.EmoteWatcher, [channel.name]}
    )

    res
  end
end
