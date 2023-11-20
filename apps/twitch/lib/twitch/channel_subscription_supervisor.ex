defmodule Twitch.ChannelSubscriptionSupervisor do
  use DynamicSupervisor
  require Logger
  alias Twitch.Queries.ChannelQuery

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    if console?() do
      IO.puts("[❗️] CONSOLE is set. Skipping subscription setup.")
    else
      spawn(&resubscribe/0)
    end

    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def resubscribe do
    resubscribe_chat_and_emotes()
    resubscribe_streamelements()
  end

  def resubscribe_chat_and_emotes do
    ChannelQuery.user_channels()
    |> Twitch.Repo.all()
    |> Stream.each(&subscribe_to_emotes(&1.name))
    |> Enum.each(&subscribe_to_chat(&1.name))
  end

  def resubscribe_streamelements do
    ChannelQuery.user_channels()
    |> Twitch.Repo.all()
    |> Enum.each(&subscribe_to_streamelements(&1.user, &1.name))
  end

  def subscribe_to_channel(channel, twitch_user) do
    res = subscribe_to_chat(channel.name)
    {:ok, _} = subscribe_to_emotes(channel.name)
    {:ok, _} = subscribe_to_streamelements(twitch_user, channel.name)
    # {:ok, _} = create_webhook_subscription(channel)
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

    Logger.info("Starting twitch chat subscription for #{channel_name}: #{inspect(res)}")

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

    Logger.info("Starting twitch emote subscription for #{channel_name}: #{inspect(res)}")

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

  def console?, do: !!System.get_env("CONSOLE")
end
