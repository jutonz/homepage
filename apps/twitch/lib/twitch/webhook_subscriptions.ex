defmodule Twitch.WebhookSubscriptions do
  alias Twitch.WebhookSubscriptions
  alias Twitch.WebhookSubscriptions.Subscription
  alias Twitch.WebhookSubscriptions.Query
  alias Twitch.WebhookSubscriptions.Topic

  def new_changeset(params \\ %{}) do
    Subscription.changeset(%Subscription{}, params)
  end

  def create(params) do
    params
    |> new_changeset()
    |> Twitch.Repo.insert()
  end

  def get_by_topic(user_id, topic) do
    Subscription
    |> Query.by_user_id(user_id)
    |> Query.by_topic(topic)
    |> Twitch.Repo.one()
  end

  def get_by_channel(%Twitch.Channel{} = channel) do
    get_by_topic(channel.user_id, Topic.topic(channel))
  end

  def subscribe_to(%Twitch.Channel{} = channel) do
    Twitch.Util.Interactor.perform([
      {WebhookSubscriptions.BuildRequest, channel},
      WebhookSubscriptions.MakeRequest,
      WebhookSubscriptions.PersistWebhook
    ])
  end

  def unsubscribe_from(%Twitch.Channel{} = channel) do
    Twitch.Util.Interactor.perform([
      {WebhookSubscriptions.BuildRequest, [channel, :unsubscribe]},
      WebhookSubscriptions.MakeRequest,
      WebhookSubscriptions.DeleteWebhook
    ])
  end

  def delete(%Subscription{} = sub) do
    Twitch.Repo.delete(sub)
  end
end
