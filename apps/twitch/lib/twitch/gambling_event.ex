defmodule Twitch.GamblingEvent do
  use Ecto.Schema
  alias Twitch.GamblingEvent

  schema "gambling_events" do
    field(:channel, :string)
    field(:gamble_type, :string)
    field(:won, :boolean)
    belongs_to(:twitch_event, Twitch.TwitchEvent)
    timestamps()
  end

  def changeset(%GamblingEvent{} = event, attrs \\ %{}) do
    event
    |> Ecto.Changeset.cast(attrs, ~w(channel gamble_type won)a)
    |> Ecto.Changeset.cast_assoc(:twitch_event, required: true)
    |> Ecto.Changeset.validate_required(~w(channel gamble_type won)a)
  end
end
