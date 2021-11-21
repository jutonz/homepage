defmodule Twitch.Eventsub.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  schema "eventsub_subscriptions" do
    field(:twitch_id, :string)
    # TODO: Also store twitch user id
    timestamps()
  end

  @required_attrs ~w[]a
  @optional_attrs ~w[twitch_id]a
  @attrs @required_attrs ++ @optional_attrs
  def changeset(%__MODULE__{} = sub, attrs \\ %{}) do
    sub
    |> cast(attrs, @attrs)
    |> validate_required(@required_attrs)
  end

  def callback(subscription) do
    # lt -s dank -p 4000
    # "https://dank.loca.lt/api/twitch/subscriptions/4"

    route_helpers = Application.get_env(:twitch, :route_helpers)
    endpoint = Application.get_env(:twitch, :endpoint)

    route_helpers.twitch_subscriptions_callback_url(
      endpoint,
      :callback,
      subscription.id
    )
  end
end
