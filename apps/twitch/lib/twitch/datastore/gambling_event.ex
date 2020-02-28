defmodule Twitch.Datastore.GamblingEvent do
  def persist(event = %Twitch.GamblingEvent{}) do
    case System.get_env("TWITCH_DATASTORE_DISABLED") do
      "true" ->
        {:ok, :datastore_disabled}

      _ ->
        case event |> event_to_entity |> Diplomat.Entity.insert() do
          [%Diplomat.Key{} = key] -> {:ok, key}
          {:error, _status} -> {:error, "Failed to insert"}
          _ -> {:error, "Something unknown"}
        end
    end
  end

  @spec event_to_entity(Twitch.GamblingEvent.t()) :: Diplomat.Entity.t()
  def event_to_entity(event = %Twitch.GamblingEvent{}) do
    entity_body = %{
      "channel" => event.channel,
      "gamble_type" => event.gamble_type,
      "won" => event.won,
      "twitch_event_id" => event.twitch_event.id,
      "inserted_at" => now_unix(),
      "updated_at" => now_unix()
    }

    entity_name = Ecto.UUID.generate()

    Diplomat.Entity.new(entity_body, entity_kind(), entity_name)
  end

  @spec entity_kind() :: String.t()
  defp entity_kind, do: "gambling-event-#{Mix.env()}"

  @spec now_unix() :: pos_integer()
  def now_unix, do: DateTime.utc_now() |> DateTime.to_unix()
end
