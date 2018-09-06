defmodule Client.TwitchEvent do
  use Ecto.Schema
  import Ecto.Changeset
  alias Client.TwitchEvent

  schema "twitch_events" do
    field(:channel, :string)
    field(:message, :string)
    field(:display_name, :string)
    field(:raw_event, :string)

    timestamps()
  end

  @doc false
  def changeset(%TwitchEvent{} = event, attrs \\ %{}) do
    event
    |> cast(attrs, [:channel, :message, :display_name, :raw_event])
    |> validate_required([:channel, :message, :display_name, :raw_event])
  end
end
