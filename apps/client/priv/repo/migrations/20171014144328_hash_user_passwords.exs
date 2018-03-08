defmodule Client.Repo.Migrations.HashUserPasswords do
  use Ecto.Migration

  def up do
    Client.User
    |> Client.Repo.all()
    |> Enum.each(fn u ->
      # currently unhashed
      password = u.password_hash
      changeset = Client.User.changeset(u, %{password: password})
      # trigger hash
      Client.Repo.update(changeset)
    end)
  end
end
