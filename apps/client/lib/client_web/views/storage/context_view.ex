defmodule ClientWeb.Storage.ContextView do
  use ClientWeb, :view

  def comma_separated_team_names(changeset) do
    names = Ecto.Changeset.get_field(changeset, :team_names)

    if names do
      Enum.join(names, ", ")
    else
      ""
    end
  end
end
