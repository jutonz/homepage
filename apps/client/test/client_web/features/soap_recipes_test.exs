defmodule ClientWeb.SoapRecipesFeatureTests do
  use ClientWeb.FeatureCase

  test "can create a recipe", %{session: session} do
    user = insert(:user)

    session
    |> visit(soap_recipe_path(@endpoint, :index, as: user.id))
    |> click(role("create-soap-recipe"))
    |> fill_in(role("soap-recipe-name-input"), with: "fff")
    |> click(role("soap-recipe-submit"))
    |> find(role("soap-recipe-name", text: "fff"))

    session
    |> visit(soap_recipe_path(@endpoint, :index))
    |> find(role("soap-recipe-name", text: "fff"))
  end

  test "can edit a recipe", %{session: session} do
    user = insert(:user)
    recipe = insert(:soap_recipe, user_id: user.id)

    session
    |> visit(soap_recipe_path(@endpoint, :edit, recipe.id, as: user.id))
    |> fill_in(role("soap-recipe-name-input"), with: "fff")
    |> click(role("soap-recipe-submit"))
    |> find(role("soap-recipe-name", text: "fff"))

    session
    |> visit(soap_recipe_path(@endpoint, :index))
    |> find(role("soap-recipe-name", text: "fff"))
  end

  test "can delete a recipe", %{session: session} do
    user = insert(:user)
    recipe = insert(:soap_recipe, user_id: user.id)

    session
    |> visit(soap_recipe_path(@endpoint, :show, recipe.id, as: user.id))
    |> accept_confirm(fn session ->
      click(session, role("soap-recipe-delete"))
    end)

    refute_has(session, role("soap-recipe-name", text: recipe.name))
    assert current_path(session) == soap_recipe_path(@endpoint, :index)
  end
end
