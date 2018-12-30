# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your repositories
# directly:
#
#     Homepage.Repo.insert!(%Homepage.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!` and so on) as
# they will fail if something goes wrong.

test_user_email = "test.user@example.com"
test_user_password = System.get_env("TEST_USER_PASSWORD")

case Client.User |> Client.Repo.get_by(email: test_user_email) do
  nil -> %Client.User{}
  user -> user
end
|> Client.User.changeset(%{
  email: test_user_email,
  password: test_user_password
})
|> Client.Repo.insert_or_update!()
