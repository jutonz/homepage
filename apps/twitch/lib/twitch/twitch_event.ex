defmodule Twitch.TwitchEvent do
  use Ecto.Schema
  alias Twitch.TwitchEvent

  schema "twitch_events" do
    field(:channel, :string)
    field(:message, :string)
    field(:display_name, :string)
    field(:raw_event, :string)

    timestamps()
  end

  def changeset(%TwitchEvent{} = event, attrs \\ %{}) do
    event
    |> Ecto.Changeset.cast(attrs, ~w(channel message display_name raw_event)a)
    |> Ecto.Changeset.validate_required(~w(channel message display_name raw_event)a)
  end
end
