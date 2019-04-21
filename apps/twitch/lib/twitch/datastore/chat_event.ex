defmodule Twitch.Datastore.ChatEvent do
  @spec persist_event(Twitch.ParsedEvent.t()) :: {:ok, Diplomat.Key.t()} | {:error, String.t()}
  def persist_event(event = %Twitch.ParsedEvent{}) do
    case event |> event_to_entity |> Diplomat.Entity.insert() do
      [%Diplomat.Key{} = key] -> {:ok, key}
      Diplomat.Client.Error -> {:error, "Failed to insert"}
      _ -> {:error, "Something unknown"}
    end
  end

  @spec event_to_entity(Twitch.ParsedEvent.t()) :: Diplomat.Entity.t()
  def event_to_entity(event = %Twitch.ParsedEvent{}) do
    entity_body = %{
      "channel" => event.channel,
      "message" => event.message,
      "display_name" => event.display_name,
      "raw_event" => event.raw_event,
      "inserted_at" => now_unix(),
      "updated_at" => now_unix()
    }

    entity_name = event.id

    Diplomat.Entity.new(entity_body, entity_kind(), entity_name)
  end

  @spec entity_kind() :: String.t()
  def entity_kind do
    "chat-event-#{Mix.env()}"
  end

  @spec now_unix() :: pos_integer()
  def now_unix do
    DateTime.utc_now() |> DateTime.to_unix()
  end
end
