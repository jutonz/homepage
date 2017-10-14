defmodule Homepage.Repo.Migrations.HashUserPasswords do
  use Ecto.Migration

  def up do
    Homepage.User
      |> Homepage.Repo.all
      |> Enum.each(fn(u) ->
        password  = u.password_hash # currently unhashed
        changeset = Homepage.User.changeset(u, %{password: password})
        Homepage.Repo.update(changeset) # trigger hash
      end)
  end
end
