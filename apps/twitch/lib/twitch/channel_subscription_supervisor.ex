defmodule Twitch.ChannelSubscriptionSupervisor do
  use DynamicSupervisor
  require Logger

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    # Resubscribe to disconnected channels
    spawn(fn ->
      Twitch.Channel
      |> Twitch.GoogleRepo.all()
      |> Twitch.GoogleRepo.preload(:user)
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
    res = subscribe_to_chat(channel, twitch_user)
    {:ok, _} = subscribe_to_emotes(channel.name)
    subscribe_to_streamelements(twitch_user, channel.name)
    res
  end

  defp subscribe_to_chat(channel, twitch_user) do
    process_name = Twitch.Channel.process_name(channel.name, twitch_user)

    res =
      DynamicSupervisor.start_child(
        __MODULE__,
        {Twitch.ChannelSubscription,
         [
           channel.name,
           twitch_user.id,
           process_name
         ]}
      )

    Logger.info("Starting twitch channel subscription for #{channel.name}: #{inspect(res)}")

    res
  end

  defp subscribe_to_emotes(channel_name) do
    DynamicSupervisor.start_child(
      __MODULE__,
      {Twitch.EmoteWatcher, [channel_name]}
    )
  end

  def subscribe_to_streamelements(twitch_user, channel_name) do
    DynamicSupervisor.start_child(
      __MODULE__,
      {Twitch.StreamelementsSubscription, [twitch_user, channel_name]}
    )
  end
end
