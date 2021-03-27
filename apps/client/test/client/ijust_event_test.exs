defmodule Client.IjustEventTest do
  use Client.DataCase, async: true

  alias Client.{IjustEvent, IjustContext, Repo}

  test "#get_for_context returns an event for a context" do
    user = insert(:user)
    {:ok, context} = user.id |> IjustContext.get_default_context()

    {:ok, event} =
      IjustEvent.create_with_occurrence(user, %{name: "test", ijust_context_id: context.id})

    {:ok, _event} = IjustEvent.get_for_context(context.id, event.id)
  end

  test "#get_for_context does not return an event belonging to another context" do
    user = insert(:user)
    {:ok, correct_context} = user.id |> IjustContext.get_default_context()

    {:ok, incorrect_context} =
      %IjustContext{}
      |> IjustContext.changeset(%{name: "weecontext", user_id: user.id})
      |> Repo.insert()

    {:ok, event} =
      IjustEvent.create_with_occurrence(user, %{
        name: "test",
        ijust_context_id: correct_context.id
      })

    {:error, _reason} = IjustEvent.get_for_context(incorrect_context.id, event.id)
  end

  test "#search_by_name returns an empty array when no matches" do
    user = insert(:user)
    {:ok, context} = IjustContext.get_default_context(user.id)

    {:ok, []} = IjustEvent.search_by_name(context.id, "doesn't exist")
  end

  test "#search_by_name returns matching events" do
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
