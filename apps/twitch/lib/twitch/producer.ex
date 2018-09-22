defmodule Twitch.EventProducer do
  def publish(%Twitch.ParsedEvent{} = event) do
    Events.publish(event, :chat_message)
  end
end
