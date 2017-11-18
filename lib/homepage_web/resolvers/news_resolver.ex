defmodule HomepageWeb.NewsResolver do
  alias Homepage.News
  alias Homepage.Link
  alias Homepage.Repo

  def all_links(_root, _args, _info) do
    links = News.list_links()
    {:ok, links}
  end

  def get_link(_root, %{ id: id }, _info) do
    case Link |> Repo.get(id) do
      link ->
        {:ok, link}
      _ ->
        {:error, "Could not find link with id #{id}"}
    end
  end

  def update_link(_root, args, _info) do
    link = Link |> Repo.get!(args[:id])
    changeset = Link.changeset(link, args)

    case Repo.update(changeset) do
      {:ok, link} ->
        {:ok, link}
      _ ->
        {:error, "Failed to update link"}
    end
  end

  def create_link(_root, args, _info) do
    # TODO provide better error messaging
    case News.create_link(args) do
      {:ok, link} ->
        {:ok, link}
      _error ->
        {:error, "Could not create link"}
    end
  end
end
