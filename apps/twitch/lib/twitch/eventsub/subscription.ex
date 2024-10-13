defmodule Twitch.Eventsub.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  schema "eventsub_subscriptions" do
    field(:twitch_id, :string)
    field(:type, :string)
    field(:version, :integer)
    field(:condition, :map)
    timestamps()
  end

  @required_attrs ~w[type version condition]a
  @optional_attrs ~w[twitch_id]a
  @attrs @required_attrs ++ @optional_attrs
  def changeset(%__MODULE__{} = sub, attrs \\ %{}) do
    # TODO: Also validate condition?
    sub
    |> cast(attrs, @attrs)
    |> validate_required(@required_attrs)
  end

  def callback(subscription) do
    # lt -s dank -p 4000
    # "https://dank.loca.lt/api/twitch/subscriptions/#{subscription.id}"

    route_helpers = Application.get_env(:twitch, :route_helpers)
    endpoint = Application.get_env(:twitch, :endpoint)

    wait_for_endpoint(endpoint, 10)

    route_helpers.twitch_subscriptions_callback_url(
      endpoint,
      :callback,
      subscription.id
    )

    "http://localhost:4000/api/twitch/subscriptions/123"
  end

  # hacky hacky
  # https://github.com/phoenixframework/phoenix/blob/main/lib/phoenix/endpoint.ex#L544-L547
  # I think this is just an issue because of how I pass in the endpoint to this
  # twich app via config.
  defp wait_for_endpoint(endpoint, remaining) do
    cond do
      remaining <= 0 ->
        # give up
        true

      :persistent_term.get({Phoenix.Endpoint, endpoint}, nil) != nil ->
        true

      true ->
        Process.sleep(250)
        wait_for_endpoint(endpoint, remaining - 1)
    end
  end
end
