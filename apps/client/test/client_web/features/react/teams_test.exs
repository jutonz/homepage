defmodule ClientWeb.React.TeamsTest do
  use ClientWeb.FeatureCase, async: true

  alias Client.Team

  # ok so the issue is that the sandbox info is given to the browser
  # via the user agent header.
  #
  # if we modify capabilities, it overrides this user agent header
  #
  # but we need to modify capabilities so that we can fix the canvas
  # issue
  #
  # what would be ideal is to merge some capabilites we want to
  # with the default ones Wallaby provides

  test "can create a team", %{session: session} do
    IO.puts("test pid #{inspect(self())}")
    user = insert(:user)

    session
    |> login(user)
    |> click(link("Settings"))
    |> find(css("form", text: "Create a team"), fn form ->
      form
      |> fill_in(fillable_field("Name"), with: "weee")
      |> click(button("Create Team"))
    end)
    |> find(css("h1", text: "weee"))

    assert Repo.get_by(Team, name: "weee")
  end
end
