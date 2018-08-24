defmodule ClientWeb.IjustResolverTest do
  use ClientWeb.ConnCase, async: true
  alias Client.{TestUtils, Session, IjustContext, IjustEvent}

  test "#search_events returns events", %{conn: conn} do
    conn = conn |> TestUtils.setup_current_user()
    {:ok, user} = conn |> Session.current_user()
    {:ok, context} = user.id |> IjustContext.get_default_context()

    {:ok, event} =
      user
      |> IjustEvent.add_for_user(%{
        name: "hello",
        ijust_context_id: context.id
      })

    query = """
    query {
      ijustEventsSearch(name: "hello", ijustContextId: #{context.id}) {
        id
      }
    }
    """

    res = conn |> post("/graphql", %{query: query}) |> json_response(200)

    event_id_as_string = to_string(event.id)
    %{"data" => %{"ijustEventsSearch" => [%{"id" => ^event_id_as_string}]}} = res
  end

  test "#search_events does not return events if I cannot view the context", %{conn: conn} do
    conn = conn |> TestUtils.setup_current_user()
    another_user = TestUtils.create_user(%{email: "wee@mail.com", password: "password123"})
    {:ok, not_my_context} = another_user.id |> IjustContext.get_default_context()

    {:ok, _not_my_event} =
      another_user
      |> IjustEvent.add_for_user(%{
        name: "hello",
        ijust_context_id: not_my_context.id
      })

    query = """
    query {
      ijustEventsSearch(name: "hello", ijustContextId: #{not_my_context.id}) {
        id
      }
    }
    """

    res = conn |> post("/graphql", %{query: query}) |> json_response(200)

    %{"errors" => [%{"message" => error_message}]} = res
    assert error_message == "No matching context"
  end
end
