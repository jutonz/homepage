defmodule Twitch.WebhookSubscriptions do
  alias Twitch.WebhookSubscriptions
  alias Twitch.WebhookSubscriptions.Subscription
  alias Twitch.WebhookSubscriptions.Query
  alias Twitch.WebhookSubscriptions.Signing
  alias Twitch.WebhookSubscriptions.Topic

  defdelegate changeset(subscription, params), to: Subscription

  def new_changeset(params \\ %{}) do
    changeset(%Subscription{}, params)
  end

  def create(params) do
    params
    |> new_changeset()
    |> Twitch.Repo.insert()
  end

  def get(id), do: Twitch.Repo.get(Subscription, id)

  def get_by_topic(user_id, topic) do
    Subscription
    |> Query.by_user_id(user_id)
    |> Query.by_topic(topic)
    |> Twitch.Repo.one()
  end

  def get_by_channel(%Twitch.Channel{} = channel) do
    get_by_topic(channel.user_id, Topic.topic(channel))
  end

  def list_by_channel(channel) do
    Subscription
    |> Query.by_topic(Topic.topic(channel))
    |> Twitch.Repo.all()
  end

  def subscribe_to(%Twitch.Channel{} = channel) do
    Twitch.Util.Interactor.perform([
      {WebhookSubscriptions.BuildRequest, channel},
      WebhookSubscriptions.MakeRequest,
      WebhookSubscriptions.PersistWebhook,
      WebhookSubscriptions.ScheduleCheckin
    ])
  end

  def unsubscribe_from(%Twitch.Channel{} = channel) do
    Twitch.Util.Interactor.perform([
      {WebhookSubscriptions.BuildRequest, [channel, :unsubscribe]},
      WebhookSubscriptions.MakeRequest,
      WebhookSubscriptions.DeleteWebhook
    ])
  end

  def update(%Subscription{} = sub, params) do
    sub |> changeset(params) |> Twitch.Repo.update()
  end

  def confirm(%Subscription{} = sub), do: update(sub, %{confirmed: true})

  def calculate_signature(body), do: Signing.signature(body)

  def delete(%Subscription{} = sub), do: Twitch.Repo.delete(sub)
end
