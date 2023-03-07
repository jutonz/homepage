defmodule ClientWeb.React.TeamsTest do
  use ClientWeb.FeatureCase, async: true

  test "can create a team", %{session: session} do
    user = insert(:user)

    session
    |> login(user)
    |> click(link("Settings"))
    |> find(css("form", text: "Create a team"), fn(form) ->
      form
      |> fill_in(fillable_field("Name"), with: "weee")
      |> click(button("Create Team"))
    end)

    #assert current_path(session) == "/"
    assert Client.Repo.exists?(Client.Team, name: "weee")
  end
end
