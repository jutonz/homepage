defmodule Events do
  @moduledoc """
  Just a wrapper for event_bus. This way not everything has to depend on that
  library directly.
  """

  def subscribe(sub_stuff) do
    EventBus.subscribe(sub_stuff)
  end

  def fetch_event(event_shadow) do
    EventBus.fetch_event(event_shadow)
  end

  def mark_as_completed(args) do
    EventBus.mark_as_completed(args)
  end

  def publish(data, topic) do
    %EventBus.Model.Event{
      id: EventBus.Util.Base62.unique_id(),
      topic: topic,
      data: data
    }
    |> EventBus.notify()
  end
end
