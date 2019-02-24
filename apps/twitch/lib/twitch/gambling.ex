defmodule Twitch.Gambling do
  @lost_roulette_regex ~r/(?<name>\w*) lost (?<lost>\d*) blyats in roulette and now has (?<remaining>\d*) .*/i
  @won_roulette_regex ~r/(?<name>\w*) won (?<lost>\d*) blyats in roulette and now has (?<remaining>\d*) .*/i
  @lost_roulette_all_in_regex ~r/(?<name>\w*) went all in and lost every single one of their (?<remaining>\d*) .*/i
  @won_roulette_all_in_regex ~r/PogChamp (?<name>\w*) went all in and won (?<won>\d*) .* now have (?<total>\d*) .*/i
  @won_slots_regex ~r/@(?<name>\w*) you got .* and U VON (?<won>\d*) blyats .*/i
  @lost_slots_regex ~r/@(?<name>\w*) you got .* and i'm taking these (?<lost>\d*) blyats .*/i

  def gambling?(%Twitch.ParsedEvent{display_name: "takeitbot"} = event) do
    roulette?(event) || slots?(event)
  end

  def gambling?(_event), do: false

  def roulette?(event) do
    cond do
      res = lost_roulette?(event) ->
        {:roulette, :lost, res}

      res = won_roulette?(event) ->
        {:roulette, :won, res}

      res = lost_roulette_all_in?(event) ->
        {:roulette, :lost, res}

      res = won_roulette_all_in?(event) ->
        {:roulette, :won, res}

      true ->
        false
    end
  end

  def lost_roulette?(event) do
    @lost_roulette_regex |> Regex.named_captures(event.message)
  end

  def won_roulette?(event) do
    @won_roulette_regex |> Regex.named_captures(event.message)
  end

  def lost_roulette_all_in?(event) do
    @lost_roulette_all_in_regex |> Regex.named_captures(event.message)
  end

  def won_roulette_all_in?(event) do
    @won_roulette_all_in_regex |> Regex.named_captures(event.message)
  end

  def slots?(event) do
    cond do
      res = won_slots?(event) ->
        {:slots, :won, res}

      res = lost_slots?(event) ->
        {:slots, :lost, res}

      true ->
        false
    end
  end

  def won_slots?(event) do
    @won_slots_regex |> Regex.named_captures(event.message)
  end

  def lost_slots?(event) do
    @lost_slots_regex |> Regex.named_captures(event.message)
  end
end
