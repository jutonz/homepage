defmodule Twitch.Eventsub.Subscriptions.DestroyOnTwitch do
  @behaviour Twitch.Util.Interactible

  def up(context, [%{twitch_id: nil}]) do
    {:ok, context}
  end

  def up(context, [%{twitch_id: twitch_id}]) do
    {_status, response} = Twitch.Api.delete_eventsub_subscription(twitch_id)
    {:ok, Map.put(context, :response, response)}
  end

  def down(context, [_sub]) do
    {:ok, context}
  end
end
