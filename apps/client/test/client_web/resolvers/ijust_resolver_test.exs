defmodule ClientWeb.IjustResolverTest do
  use ClientWeb.ConnCase, async: true
  alias Client.{TestUtils, IjustOccurrence, Repo}

  describe "get_event_occurrences" do
    test "returns occurrences", %{conn: conn} do
      conn = conn |> TestUtils.setup_current_user()
      event_id = "123"
      {:ok, occurrence} =
        %IjustOccurrence{}
        |> IjustOccurrence.changeset(%{event_id: event_id})
        |> Repo.insert()
      query = """
        query {
          getIjustEventOccurrences(event_id: #{event_id}) { id }
        }
      """

      res = conn |> post("/graphql", %{query: query}) |> json_response(200)

      %{"data" => %{"getIjustEventOccurrences" => [%{"id" => id}]}} = res
      assert id == to_string(occurrence.id)
    end
  end
end
