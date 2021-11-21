defmodule Twitch.Eventsub.Subscriptions.Destroy do
  @behaviour Twitch.Util.Interactible

  def up(context, [sub]) do
    Twitch.Repo.delete(sub)
    {:ok, context}
  end

  def down(context, [_sub]) do
    {:ok, context}
  end
end
