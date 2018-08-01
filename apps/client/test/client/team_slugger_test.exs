defmodule Client.TeamSluggerTest do
  use Client.DataCase, async: true
  alias Client.{Team, Repo, TeamSlugger}

  ##############################################################################
  # find_a_slug
  ##############################################################################

  test "#find_a_slug returns a slug" do
    name = "wee"
    expected = "wee"

    actual = TeamSlugger.find_a_slug(name)

    assert actual == expected
  end

  test "#find_a_slug adds a count on name collision" do
    %Team{name: "wee"} |> Team.changeset() |> Repo.insert!()
    expected = "wee-1"

    actual = TeamSlugger.find_a_slug("wee")

    assert actual == expected
  end

  ##############################################################################
  # generate_slug
  ##############################################################################

  test "#generate_slug makes a slug without a number when index is 0" do
    name = "wee"
    expected = "wee"

    actual = TeamSlugger.generate_slug(name, 0)

    assert actual == expected
  end

  test "#generate_slug makes a slug with a number when index is > 0" do
    name = "wee"
    expected = "wee-1"

    actual = TeamSlugger.generate_slug(name, 1)

    assert actual == expected
  end

  ##############################################################################
  # maybe_add_slug
  ##############################################################################

  test "#maybe_add_slug adds a slug if one is not present" do
    team =
      %Team{name: "wee"}
      |> Team.changeset()
      |> TeamSlugger.maybe_add_slug()

    assert team.changes.slug == "wee"
  end

  test "#maybe_add_slug updates the slug if the name is changed" do
    %Team{name: "wee"} |> Team.changeset() |> Repo.insert!()

    changed =
      %Team{name: "woah"}
      |> Team.changeset()
      |> TeamSlugger.maybe_add_slug()

    assert changed.changes.slug == "woah"
  end

  test "#maybe_add_slug leaves the existing slug if the name is unchanged" do
    team = %Team{name: "wee"} |> Team.changeset() |> Repo.insert!()
    unchanged = team |> Team.changeset() |> TeamSlugger.maybe_add_slug()

    assert unchanged.changes |> Map.has_key?(:slug) == false
  end
end
