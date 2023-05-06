defmodule Client.IjustEventTest do
  use Client.DataCase, async: true

  alias Client.{IjustEvent, IjustContext, Repo}

  describe ".get_for_user/2" do
    test "returns an event belonging to a user" do
      user = insert(:user)
      {:ok, context} = user.id |> IjustContext.get_default_context()

      {:ok, event} =
        IjustEvent.create_with_occurrence(user, %{name: "test", ijust_context_id: context.id})

      {:ok, _event} = IjustEvent.get_for_user(user, event.id)
    end

    test "does not return an event belonging to another user" do
      [me, not_me] = insert_pair(:user)
      {:ok, my_context} = me.id |> IjustContext.get_default_context()

      {:ok, _not_my_context} =
        %IjustContext{}
        |> IjustContext.changeset(%{name: "weecontext", user_id: not_me.id})
        |> Repo.insert()

      {:ok, event} =
        IjustEvent.create_with_occurrence(not_me, %{
          name: "test",
          ijust_context_id: my_context.id
        })

      {:error, _reason} = IjustEvent.get_for_user(not_me, event.id)
    end
  end

  describe ".search_by_name/2" do
    test "returns an empty array when no matches" do
      user = insert(:user)
      {:ok, context} = IjustContext.get_default_context(user.id)

      {:ok, []} = IjustEvent.search_by_name(context.id, "doesn't exist")
    end

    test "returns matching events" do
      user = insert(:user)
      {:ok, context} = IjustContext.get_default_context(user.id)

      {:ok, event} =
        user
        |> IjustEvent.add_for_user(%{
          name: "hello",
          ijust_context_id: context.id
        })

      {:ok, [^event]} = IjustEvent.search_by_name(context.id, "hello")
    end
  end
end
