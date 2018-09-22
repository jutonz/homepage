defmodule Twitch.EventParseFailureLogger do
  use GenServer
  require Logger

  # How many messages to keep
  @keep 1000

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    state = []
    {:ok, state}
  end

  def log(raw_message, failure_reason) do
    GenServer.cast(__MODULE__, {:log, raw_message, failure_reason})
  end

  def get_log() do
    GenServer.call(__MODULE__, :get_log)
  end

  def handle_cast({:log, raw_message, failure_reason}, state) do
    Logger.debug(
      "Could not parse message (#{failure_reason}), so it was skipped: #{inspect(raw_message)}"
    )

    new_state =
      if length(state) >= @keep do
        # Don't keep more than @keep events
        state
      else
        [raw_message | state]
      end

    Logger.info("Stored #{length(state)} invalid messages")

    {:noreply, new_state}
  end

  def handle_call(:get_log, _from, state) do
    {:reply, state, state}
  end
end
