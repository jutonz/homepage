defmodule Twitch.Eventsub.Subscriptions.Create do
  @behaviour Twitch.Util.Interactible

  alias Twitch.{
    Eventsub.Subscription,
    Repo
  }

  def up(context, []) do
    case create_blank_sub() do
      {:ok, sub} ->
        {:ok, Map.put(context, :subscription, sub)}

      {:error, changeset} ->
        {:ok, Map.put(context, :subscription, changeset)}
    end
  end

  def down(%{subscription: sub} = context, []) do
    Repo.delete(sub)
    {:ok, context}
  end

  defp create_blank_sub do
    %Subscription{}
    |> Subscription.changeset(%{})
    |> Repo.insert()
  end
end
