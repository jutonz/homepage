defmodule Twitch.WebhookSubscriptions.ScheduleCheckin do
  @behaviour Twitch.Util.Interactible

  alias Twitch.WebhookSubscriptions
  alias Twitch.WebhookSubscriptions.Subscription

  def up(%Subscription{} = sub) do
    spawn(fn ->
      :timer.sleep(30_000)
      check_in(sub)
    end)

    {:ok, sub}
  end

  def down(%Subscription{} = sub), do: {:ok, sub}

  defp check_in(%Subscription{id: id}) do
    id |> WebhookSubscriptions.get() |> delete_unless_confirmed()
  end

  defp delete_unless_confirmed(nil), do: nil

  defp delete_unless_confirmed(%Subscription{confirmed: true} = sub),
    do: sub

  defp delete_unless_confirmed(%Subscription{confirmed: false} = sub),
    do: WebhookSubscriptions.delete(sub)
end
