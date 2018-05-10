defmodule Client.IjustContextTest do
  use Client.DataCase, async: true
  alias Client.{IjustEvent, IjustContext, Repo, TestUtils}

  describe ".create_default_context" do
    test "makes a default context for the given user_id" do
      user = TestUtils.create_user()

      {:ok, context} = user.id |> IjustContext.create_default_context()

      assert context.user_id == user.id
      assert context.name == "default"
    end
  end

  describe ".get_default_context" do
    test "returns an existing default context" do
      user = TestUtils.create_user()
      {:ok, expected} = user.id |> IjustContext.create_default_context()

      {:ok, actual} = IjustContext.get_default_context(user.id)

      assert actual == expected
    end

    test "creates a new default context if one does not exist already" do
      user = TestUtils.create_user()
      context = IjustContext |> Repo.get_by(name: "default", user_id: user.id)
      assert context == nil

      {:ok, _context} = IjustContext.get_default_context(user.id)

      context = IjustContext |> Repo.get_by(name: "default", user_id: user.id)
      refute context == nil
    end
  end

  describe ".get_for_user" do
    test "returns an error if no contexts match" do
      user = TestUtils.create_user()
      {:error, "No matching context"} = IjustContext.get_for_user(123, user.id)
    end

    test "returns an existing context" do
      user = TestUtils.create_user()
      {:ok, expected} = IjustContext.create_default_context(user.id)

      {:ok, actual} = IjustContext.get_for_user(expected.id, user.id)

      assert actual == expected
    end
  end

  describe ".recent_events" do
    test "returns recent events" do
      user = TestUtils.create_user()
      {:ok, context} = user.id |> IjustContext.create_default_context()
      event_args = %{ijust_context_id: context.id, name: "hello"}
      {:ok, event} = IjustEvent.create_with_occurrence(user, event_args)

      {:ok, recent_events} = IjustContext.recent_events(context.id)

      assert recent_events == [event]
    end

    test "does not return events from other contexts" do
      user = TestUtils.create_user()

      {:ok, context1} =
        %IjustContext{}
        |> IjustContext.changeset(%{user_id: user.id, name: "context1"})
        |> Repo.insert()

      {:ok, event1} =
        IjustEvent.create_with_occurrence(user, %{
          ijust_context_id: context1.id,
          name: "wee"
        })

      {:ok, context2} =
        %IjustContext{}
        |> IjustContext.changeset(%{user_id: user.id, name: "context2"})
        |> Repo.insert()

      {:ok, event2} =
        IjustEvent.create_with_occurrence(user, %{
          ijust_context_id: context2.id,
          name: "wee"
        })

      {:ok, recent_events1} = context1.id |> IjustContext.recent_events()
      assert recent_events1 == [event1]

      {:ok, recent_events2} = context2.id |> IjustContext.recent_events()
      assert recent_events2 == [event2]
    end
  end
end
