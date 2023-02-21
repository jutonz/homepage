defmodule ClientWeb.React.AuthTest do
  use ClientWeb.FeatureCase, async: true

  describe "signup" do
    test "successfully", %{session: session} do
      params = params_for(:user)

      session
      |> visit("/")
      |> click(link("Or signup"))
      |> fill_in(fillable_field("email"), with: params[:email])
      |> fill_in(fillable_field("password"), with: params[:password])
      |> click(button("Signup"))
      |> find(css("a", text: "Logout"))

      assert current_path(session) == "/"
      assert Client.Repo.exists?(Client.User, email: params[:email])
    end
  end

  describe "login" do
    test "successfully", %{session: session} do
      user = insert(:user)

      session
      |> login(user)
    end
  end

  describe "logout" do
    test "sends the user back to the login page", %{session: session} do
      user = insert(:user)

      session
      |> login(user)
      |> click(css("a", text: "Logout"))
      |> assert_has(css("h1", text: "Login"))

      assert current_url(session) == ClientWeb.Endpoint.url() <> "/#/login"
    end
  end
end
