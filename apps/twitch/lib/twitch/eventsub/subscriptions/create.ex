defmodule Twitch.Eventsub.Subscriptions.Create do
  @behaviour Twitch.Util.Interactible

  alias Twitch.{
    Eventsub.Subscription,
    Repo
  }

  def up(context, [options]) do
    case create_local_sub(options) do
      {:ok, sub} ->
        {:ok, Map.put(context, :subscription, sub)}

      {:error, changeset} ->
        {:ok, Map.put(context, :subscription, changeset)}
    end
  end

  def down(%{subscription: sub} = context, [_options]) do
    Repo.delete(sub)
    {:ok, context}
  end

  defp create_local_sub(attrs) do
    %Subscription{}
    |> Subscription.changeset(attrs)
    |> Repo.insert()
  end
end
