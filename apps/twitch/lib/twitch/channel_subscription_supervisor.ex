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
      |> Enum.each(&subscribe_to_chat(&1.name))
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
    res = subscribe_to_chat(channel.name)
    {:ok, _} = subscribe_to_emotes(channel.name)
    {:ok, _} = subscribe_to_streamelements(twitch_user, channel.name)
    res
  end

  def unsubscribe_from_channel(channel, twitch_user) do
    se_pid =
      twitch_user
      |> Twitch.StreamelementsSubscription.name(String.trim_leading(channel.name, "#"))
      |> Process.whereis()

    if se_pid do
      DynamicSupervisor.terminate_child(__MODULE__, se_pid)
    else
      :ok
    end
  end

  def subscribe_to_chat(channel_name) do
    res =
      DynamicSupervisor.start_child(
        __MODULE__,
        {Twitch.ChatSubscription, channel_name}
      )

    Logger.info("Starting twitch channel subscription for #{channel_name}: #{inspect(res)}")

    case res do
      {:ok, pid} -> {:ok, pid}
      {:error, {:already_started, pid}} -> {:ok, pid}
      _ -> res
    end
  end

  def subscribe_to_emotes(channel_name) do
    res =
      DynamicSupervisor.start_child(
        __MODULE__,
        {Twitch.EmoteWatcher, [channel_name]}
      )

    case res do
      {:ok, pid} -> {:ok, pid}
      {:error, {:already_started, pid}} -> {:ok, pid}
      _ -> res
    end
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
