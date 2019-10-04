defmodule Twitch.WebhookSubscriptions.Subscription do
  use Ecto.Schema
  import Ecto.Changeset
  alias Twitch.WebhookSubscriptions.Subscription

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "webhook_subscriptions" do
    field(:topic, :string)
    field(:secret, :string)
    field(:expires_at, :naive_datetime)
    field(:user_id, :integer)
    # field(:resubscribe, :boolean)
    timestamps()
  end

  def changeset(%Subscription{} = sub, attrs \\ %{}) do
    sub
    |> cast(attrs, required_attrs())
    |> maybe_gen_secret()
    |> validate_required(required_attrs())
    |> unique_constraint(:topic, name: :webhook_subscriptions_user_id_topic_index)
  end

  def maybe_gen_secret(changeset) do
    case get_field(changeset, :secret) do
      nil -> put_change(changeset, :secret, gen_secret())
      _ -> changeset
    end
  end

  def gen_secret, do: Ecto.UUID.generate()

  def callback do
    # lt -s dank -p 4000
    # "https://dank.localtunnel.me/api/twitch/subscriptions/callback"

    route_helpers = Application.get_env(:twitch, :route_helpers)
    endpoint = Application.get_env(:twitch, :endpoint)

    route_helpers.twitch_subscriptions_callback_url(
      endpoint,
      :callback
    )
  end

  def required_attrs do
    ~w[topic secret expires_at user_id]a
  end
end
