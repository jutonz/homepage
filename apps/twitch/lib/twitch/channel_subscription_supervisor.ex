defmodule Twitch.ChannelSubscriptionSupervisor do
  use DynamicSupervisor

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def subscribe_to_channel(channel, oauth_token) do
    DynamicSupervisor.start_child(
      __MODULE__,
      {Twitch.ChannelSubscription, [channel, oauth_token]}
    )
  end
end
