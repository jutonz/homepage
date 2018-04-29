defmodule Client.IjustEventTest do
  use Client.DataCase, async: true

  alias Client.{IjustEvent, IjustContext, Repo, TestUtils}

  test "#get_for_context returns an event for a context" do
    user = TestUtils.create_user()
    {:ok, context} = user |> IjustContext.get_default_context()
    {:ok, event} = IjustEvent.create_with_occurrence(context.id, user, %{name: "test"})

    {:ok, _event} = IjustEvent.get_for_context(context.id, event.id)
  end

  test "#get_for_context does not return an event belonging to another context" do
    user = TestUtils.create_user()
    {:ok, correct_context} = user |> IjustContext.get_default_context()

    {:ok, incorrect_context} =
      %IjustContext{}
      |> IjustContext.changeset(%{name: "weecontext"})
      |> Ecto.Changeset.put_assoc(:user, user)
      |> Repo.insert()

    {:ok, event} = IjustEvent.create_with_occurrence(correct_context.id, user, %{name: "test"})

    {:error, _reason} = IjustEvent.get_for_context(incorrect_context.id, event.id)
  end
end
