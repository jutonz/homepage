defmodule Twitch.Eventsub.Subscriptions do
  alias Twitch.{
    Eventsub.Subscription,
    Eventsub.Subscriptions.Callback,
    Eventsub.Subscriptions.Create,
    Eventsub.Subscriptions.DestroyOnTwitch,
    Eventsub.Subscriptions.Destroy,
    Eventsub.Subscriptions.MakeRequest,
    Eventsub.Subscriptions.Update,
    Repo,
    Util.Interactor
  }

  def list do
    Repo.all(Subscription)
  end

  @spec create(MakeRequest.options()) :: {:ok, any()} | {:error, any()}
  def create(options) do
    Interactor.perform(%{}, [
      {Create, []},
      {MakeRequest, [options]},
      {Update, []}
    ])
  end

  def get(id) do
    Repo.get(Subscription, id)
  end

  def get_by_twitch_id(twitch_id) do
    Repo.get_by(Subscription, twitch_id: twitch_id)
  end

  def callback(subscription, body) do
    type = get_in(body, ["subscription", "type"])
    Callback.perform(subscription, body, type)
  end

  def destroy(subscription) do
    Interactor.perform(%{}, [
      {DestroyOnTwitch, [subscription]},
      {Destroy, [subscription]}
    ])
  end

  def calculate_signature(message) do
    signature =
      :hmac
      |> :crypto.mac(:sha256, secret(), message)
      |> Base.encode16()
      |> String.downcase()

    "sha256=" <> signature
  end

  def secret do
    Application.get_env(:twitch, :webhook_secret)
  end
end
