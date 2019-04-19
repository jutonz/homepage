defmodule Twitch.Datastore.ChatEventTest do
  use Twitch.DataCase, async: true
  alias Twitch.Datastore

  test "event_to_entity/1 stores the channel" do
    event = build(:parsed_event)
    entity = Datastore.ChatEvent.event_to_entity(event)
    assert entity.properties["channel"].value == event.channel
  end

  test "event_to_entity/1 stores the message" do
    event = build(:parsed_event)
    entity = Datastore.ChatEvent.event_to_entity(event)
    assert entity.properties["message"].value == event.message
  end

  test "event_to_entity/1 stores the display_name" do
    event = build(:parsed_event)
    entity = Datastore.ChatEvent.event_to_entity(event)
    assert entity.properties["display_name"].value == event.display_name
  end

  test "event_to_entity/1 stores the raw_event" do
    event = build(:parsed_event)
    entity = Datastore.ChatEvent.event_to_entity(event)
    assert entity.properties["raw_event"].value == event.raw_event
  end

  test "event_to_entity/1 uses the right key" do
    event = build(:parsed_event)
    entity = Datastore.ChatEvent.event_to_entity(event)
    expected_key = %Diplomat.Key{kind: "chat-event-test", name: event.id}
    assert expected_key == entity.key
  end
end
