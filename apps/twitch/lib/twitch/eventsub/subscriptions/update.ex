defmodule Twitch.Eventsub.Subscriptions.Update do
  @behaviour Twitch.Util.Interactible
  alias Twitch.Eventsub.Subscription

  def up(context, []) do
    %{data: %{"data" => [data]}} = context[:response]
    sub = context[:subscription]
    changes = %{twitch_id: data["id"]}

    {status, sub} =
      sub
      |> Subscription.changeset(changes)
      |> Twitch.Repo.update()

    {status, Map.put(context, :subscription, sub)}
  end

  def down(context, []) do
    {:ok, context}
  end
end
