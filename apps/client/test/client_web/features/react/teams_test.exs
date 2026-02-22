defmodule ClientWeb.React.TeamsTest do
  use ClientWeb.FeatureCase, async: true

  alias Client.Team

  feature "can create a team", %{session: session} do
    user = insert(:user)
    team_name = "team-#{rand_string()}"

    session
    |> login(user)
    |> click(link("Settings"))
    |> find(css("form", text: "Create a team"), fn form ->
      form
      |> fill_in(fillable_field("Name"), with: team_name)
      |> click(button("Create Team", disabled: false))
    end)

    team =
      wait_for_condition(10, fn ->
        case Repo.get_by(Team, name: team_name) do
          nil -> :error
          team -> {:ok, team}
        end
      end)

    wait_for_hash_path(session, "#/teams/#{team.id}")
  end
end
