defmodule ClientWeb.IjustResolverTest do
  use ClientWeb.ConnCase, async: true
  alias Client.{TestUtils, Repo, Session, IjustContext, IjustEvent}

  test "#search_events returns events", %{conn: conn} do
    conn = conn |> TestUtils.setup_current_user()
    {:ok, user} = conn |> Session.current_user()
    {:ok, context} = user.id |> IjustContext.get_default_context()
    {:ok, event} = user |> IjustEvent.add_for_user(%{
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

    require IEx; IEx.pry()


  end

  test "#search_events does not return events if I cannot view the context" do
  end

  # describe "get_event_occurrences" do
  # test "returns occurrences", %{conn: conn} do
  # conn = conn |> TestUtils.setup_current_user()
  # event_id = "123"

  # {:ok, occurrence} =
  # %IjustOccurrence{}
  # |> IjustOccurrence.changeset(%{event_id: event_id})
  # |> Repo.insert()

  # query = """
  # query {
  # getIjustEventOccurrences(event_id: #{event_id}) { id }
  # }
  # """

  # res = conn |> post("/graphql", %{query: query}) |> json_response(200)

  # %{"data" => %{"getIjustEventOccurrences" => [%{"id" => id}]}} = res
  # assert id == to_string(occurrence.id)
  # end
  # end
end
