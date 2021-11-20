defmodule Twitch.WebhookSubscriptions.Subscription do
  alias Twitch.WebhookSubscriptions.Subscription
  import Ecto.Changeset
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "webhook_subscriptions" do
    field(:topic, :string)
    field(:secret, :string)
    field(:expires_at, :naive_datetime)
    field(:user_id, :integer)
    field(:confirmed, :boolean)
    # field(:resubscribe, :boolean)
    timestamps()
  end


  @required_attrs ~w[topic secret expires_at user_id]a
  @optional_attrs ~w[confirmed]a
  @attrs @optional_attrs ++ @required_attrs
  def changeset(%Subscription{} = sub, attrs \\ %{}) do
    sub
    |> cast(attrs, @attrs)
    |> validate_required(@required_attrs)
    |> unique_constraint(:topic, name: :webhook_subscriptions_user_id_topic_index)
  end

  def maybe_add_secret(changeset) do
    case get_field(changeset, :secret) do
      nil -> put_change(changeset, :secret, secret())
      _ -> changeset
    end
  end

  def secret, do: Application.get_env(:twitch, :webhook_secret)

  def callback(_user_id) do
     #lt -s dank -p 4000
     "https://dank.loca.lt/api/twitch/subscriptions/callback"

    #route_helpers = Application.get_env(:twitch, :route_helpers)
    #endpoint = Application.get_env(:twitch, :endpoint)

    #route_helpers.twitch_subscriptions_callback_url(
      #endpoint,
      #:callback,
      #user_id
    #)
  end
end
