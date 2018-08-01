defmodule Client.TeamSlugger do
  alias Client.{Repo, Team}

  def maybe_add_slug(changeset) do
    # re-slug if there is 1) no existing slug, or 2) the name has changed
    no_slug = !changeset.data.slug
    name_changed = changeset.changes |> Map.has_key?(:name)

    if no_slug || name_changed do
      name = if name_changed, do: changeset.changes.name, else: changeset.data.name
      slug = find_a_slug(name)
      changeset |> Ecto.Changeset.change(%{slug: slug})
    else
      changeset
    end
  end

  def generate_slug(name, index) when is_number(index) do
    slug = name |> Client.Slug.generate()

    if index > 0 do
      "#{slug}-#{to_string(index)}"
    else
      slug
    end
  end

  def find_a_slug(name, slug_guess \\ nil, tries \\ 0) do
    slug_guess = slug_guess || generate_slug(name, tries)

    existing = Team |> Repo.get_by(slug: slug_guess)

    case existing do
      nil -> slug_guess
      _ -> find_a_slug(name, nil, tries + 1)
    end
  end
end
