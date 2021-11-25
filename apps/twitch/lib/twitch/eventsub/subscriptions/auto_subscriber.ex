defmodule Twitch.Eventsub.Subscriptions.AutoSubscriber do
  use GenServer
  alias Twitch.Eventsub.Subscriptions.EnsureSubscription

  def start_link(args) do
    GenServer.start_link(__MODULE__, [], args)
  end

  def init(_args) do
    if console?() || subscriptions() == [] do
      :ignore
    else
      {:ok, nil, {:continue, :subscribe}}
    end
  end

  def handle_continue(:subscribe, state) do
    Enum.each(subscriptions(), &EnsureSubscription.call/1)
    {:noreply, state}
  end

  defp subscriptions do
    Application.fetch_env!(:twitch, :eventsub_subscriptions)
  end

  defp console? do
    !!System.get_env("CONSOLE")
  end
end
