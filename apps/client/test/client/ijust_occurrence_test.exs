defmodule Client.IjustOccurrenceTest do
  use Client.DataCase, async: true
  # alias Client.{IjustOccurrence, Repo, IjustEvent}

  describe "get_for_event" do
    # test "returns an occurrences for an event_id" do
    # this_event_id = "123"
    # other_event_id = "456"
    # {:ok, this_occurrence} =
    # %IjustOccurrence{}
    # |> IjustOccurrence.changeset(%{ijust_event_id: this_event_id})
    # |> Repo.insert
    # {:ok, other_occurrence} =
    # %IjustOccurrence{}
    # |> IjustOccurrence.changeset(%{ijust_event_id: other_event_id})
    # |> Repo.insert

    # {:ok, occurrences} = this_event_id |> IjustOccurrence.get_for_event()
    # require IEx; IEx.pry
    # assert expected.id == actual.id
    # end

    # test "returns nothing if there is no matching occurrence" do
    # {:ok, []} = "123" |> IjustOccurrence.get_for_event()
    # end

    # test "returns only occurrences for the given event" do
    # event_id = "123"
    # {:ok, matching_occurrence} =
    # %IjustOccurrence{}
    # |> IjustOccurrence.changeset(%{event_id: event_id})
    # |> Repo.insert()
    # {:ok, _not_matching_occurrence} =
    # %IjustOccurrence{}
    # |> IjustOccurrence.changeset(%{event_id: event_id})
    # |> Repo.insert()

    # {:ok, [actual]} = event_id |> IjustOccurrence.get_for_event()
    # assert matching_occurrence.id == actual.id
    # end
  end
end
