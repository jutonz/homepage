defmodule Twitch.WebhookSubscriptions.Log do
  use GenServer

  # How many messages to keep
  @keep 1000

  ##############################################################################
  # GenServer internals
  ##############################################################################

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    state = %{messages: [], count: 0}
    {:ok, state}
  end

  ##############################################################################
  # Public API
  ##############################################################################
  #
  def log(message), do: GenServer.cast(__MODULE__, {:log, message})
  def get_log, do: GenServer.call(__MODULE__, :get_log)

  ##############################################################################
  # Private API
  ##############################################################################

  def handle_cast({:log, message}, state) do
    %{messages: messages, count: count} = state

    new_state =
      if count >= @keep do
        state
      else
        %{
          messages: [message | messages],
          count: count + 1
        }
      end

    {:noreply, new_state}
  end

  def handle_call(:get_log, _from, state) do
    IO.inspect(state)
    {:reply, state[:messages], state}
  end
end
