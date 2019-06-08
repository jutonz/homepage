defmodule Twitch.Datastore.GamblingEventTest do
  use Twitch.DataCase, async: true
  alias Twitch.Datastore

  test "event_to_entity/1 stores the channel" do
    event = build(:gambling_event)
    entity = Datastore.GamblingEvent.event_to_entity(event)
    assert entity.properties["channel"].value == event.channel
  end

  test "event_to_entity/1 stores the gamble type" do
    event = build(:gambling_event)
    entity = Datastore.GamblingEvent.event_to_entity(event)
    assert entity.properties["gamble_type"].value == event.gamble_type
  end

  test "event_to_entity/1 stores won" do
    event = build(:gambling_event)
    entity = Datastore.GamblingEvent.event_to_entity(event)
    assert entity.properties["won"].value == event.won
  end

  test "event_to_entity/1 stores the twitch_event_id" do
    event = build(:gambling_event)
    entity = Datastore.GamblingEvent.event_to_entity(event)
    assert entity.properties["twitch_event_id"].value == event.twitch_event.id
  end

  test "event_to_entity/1 stores inserted_at" do
    event = build(:gambling_event)
    entity = Datastore.GamblingEvent.event_to_entity(event)
    assert entity.properties["inserted_at"].value
  end

  test "event_to_entity/1 stores updated_at" do
    event = build(:gambling_event)
    entity = Datastore.GamblingEvent.event_to_entity(event)
    assert entity.properties["updated_at"].value
  end
end
