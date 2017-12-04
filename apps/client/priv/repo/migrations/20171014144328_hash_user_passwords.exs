defmodule Client.Repo.Migrations.HashUserPasswords do
  use Ecto.Migration

  def up do
    Client.User
      |> Client.Repo.all
      |> Enum.each(fn(u) ->
        password  = u.password_hash # currently unhashed
        changeset = Client.User.changeset(u, %{password: password})
        Client.Repo.update(changeset) # trigger hash
      end)
  end
end
