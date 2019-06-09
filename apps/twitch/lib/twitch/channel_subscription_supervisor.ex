defmodule Twitch.ChannelSubscriptionSupervisor do
  use DynamicSupervisor
  require Logger
  alias Twitch.Queries.ChannelQuery

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    spawn(&resubscribe/0)
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def resubscribe do
    resubscribe_chat_and_emotes()
    resubscribe_streamelements()
  end

  def resubscribe_chat_and_emotes do
    Twitch.Repo.transaction(fn ->
      ChannelQuery.user_channels()
      |> Twitch.Repo.stream()
      |> Stream.each(&subscribe_to_emotes(&1.name))
      |> Enum.each(&subscribe_to_chat(&1, &1.user))
    end)
  end

  def resubscribe_streamelements do
    Twitch.Repo.transaction(fn ->
      ChannelQuery.user_channels()
      |> Twitch.Repo.stream()
      |> Enum.each(&subscribe_to_streamelements(&1.user, &1.name))
    end)
  end

  def subscribe_to_channel(channel, twitch_user) do
    res = subscribe_to_chat(channel, twitch_user)
    {:ok, _} = subscribe_to_emotes(channel.name)
    {:ok, _} = subscribe_to_streamelements(twitch_user, channel.name)
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
    res =
      DynamicSupervisor.start_child(
        __MODULE__,
        {Twitch.StreamelementsSubscription, [twitch_user, channel_name]}
      )

    case res do
      {:ok, _} -> {:ok, :connected}
      :ignore -> {:ok, :not_enabled}
      _ -> {:error, res}
    end
  end
end
