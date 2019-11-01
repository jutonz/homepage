defmodule Twitch.WebhookSubscriptions.Callbacks.Callback do
  alias __MODULE__
  import Ecto.Changeset
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "webhook_subscriptions_callbacks" do
    field(:subscription_id, Ecto.UUID)
    field(:user_id, :string)
    field(:game_id, :string)
    field(:body, :map)
    timestamps()
  end

  def changeset(%Callback{} = callback, attrs \\ %{}) do
    callback
    |> cast(attrs, optional_attrs() ++ required_attrs())
    |> validate_required(required_attrs())
  end

  def required_attrs, do: ~w[user_id game_id body subscription_id]a
  def optional_attrs, do: ~w[]a
end
