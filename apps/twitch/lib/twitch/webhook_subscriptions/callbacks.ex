defmodule Twitch.WebhookSubscriptions.Callbacks do
  alias Twitch.WebhookSubscriptions.Callbacks.Callback
  alias Twitch.WebhookSubscriptions.Log

  defdelegate changeset(subscription, params), to: Callback

  def new_changeset(params \\ %{}), do: changeset(%Callback{}, params)

  def create(sub_id, %{"data" => [callback_params]} = body) do
    callback_params
    |> Map.put("subscription_id", sub_id)
    |> Map.put("body", body)
    |> new_changeset()
    |> Twitch.Repo.insert()
  end

  def create(sub_id, params) do
    Log.log(%{
      subscription_id: sub_id,
      params: params
    })
  end
end
