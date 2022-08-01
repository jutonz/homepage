defmodule ClientWeb.StorageFeatureTests do
  use ClientWeb.FeatureCase, async: true
  import Wallaby.Query, only: [button: 1, css: 2, link: 1]

  test "can create a context", %{session: session} do
    user = insert(:user)
    [team1, team2] = insert_list(2, :team, users: [user])
    name = rand_string()

    session
    |> visit(Routes.storage_context_path(@endpoint, :index, as: user.id))
    |> click(link("New Context"))
    |> fill_in(role("name-input"), with: name)
    |> fill_in(role("team-names-input"), with: "#{team1.name}, #{team2.name}")
    |> fill_in(role("default-location"), with: "Default Location")
    |> click(button("Create"))
    |> assert_has(role("storage-context-name", text: name))
    |> assert_has(css("tr", text: team1.name))
    |> assert_has(css("tr", text: team2.name))
  end

  test "can update a context", %{session: session} do
    user = insert(:user)
    team_lead = insert(:user)
    team = insert(:team, users: [team_lead, user])
    context = insert(:storage_context, creator: team_lead, teams: [team])
    other_team = insert(:team, users: [user])
    path = Routes.storage_context_path(@endpoint, :show, context, as: user.id)

    session
    |> visit(path)
    |> click(link("✎"))
    |> fill_in(role("name-input"), with: "new name")
    |> fill_in(role("team-names-input"), with: "#{team.name}, #{other_team.name}")
    |> click(button("Update"))
    |> assert_has(role("storage-context-name", text: "new name"))
    |> assert_has(css("tr", text: team.name))
    |> assert_has(css("tr", text: other_team.name))
  end

  test "can insert an item", %{session: session} do
    user = insert(:user)
    context = insert(:storage_context, creator_id: user.id, default_location: "Default Location")
    path = Routes.storage_context_path(@endpoint, :show, context, as: user.id)

    session
    |> visit(path)
    |> click(link("New item"))
    |> assert_has(role("location-input", value: "Default Location"))
    |> fill_in(role("name-input"), with: "Name")
    |> fill_in(role("description-input"), with: "Name")
    |> fill_in(role("location-input"), with: "Other Location")
    |> click(button("Create"))
  end
end
