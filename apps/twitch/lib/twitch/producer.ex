defmodule Twitch.EventProducer do
  def publish(%Twitch.ParsedEvent{} = event) do
    %EventBus.Model.Event{
      id: EventBus.Util.Base62.unique_id(),
      topic: :chat_message,
      data: event
    }
    |> EventBus.notify()
  end
end
