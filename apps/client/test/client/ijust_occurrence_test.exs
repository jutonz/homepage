defmodule Client.IjustOccurrenceTest do
  use Client.DataCase, async: true
  alias Client.{IjustOccurrence, Repo}

  test ".get_for_event returns an occurrences for an event_id" do
    event_id = "123"

    {:ok, expected} =
      %IjustOccurrence{}
      |> IjustOccurrence.changeset(%{event_id: event_id})
      |> Repo.insert()

    {:ok, [actual]} = event_id |> IjustOccurrence.get_for_event()
    assert expected.id == actual.id
  end

  test ".get_for_event returns nothing if there is no matching occurrence" do
    {:ok, []} = "123" |> IjustOccurrence.get_for_event()
  end
end
