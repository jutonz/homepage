defmodule ClientWeb.Storage.ContextController do
  use ClientWeb, :controller

  plug :put_view, ClientWeb.Storage.ContextView

  alias Client.{
    Repo,
    Session,
    Storage
  }

  def index(conn, _params) do
    contexts =
      conn
      |> Session.current_user_id()
      |> Storage.list_contexts()
      |> Repo.preload(:teams)

    render(conn, "index.html", contexts: contexts)
  end

  def new(conn, _params) do
    changeset = Storage.new_context_changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"context" => context_params}) do
    user_id = Session.current_user_id(conn)
    context_params = Map.put(context_params, "creator_id", user_id)

    team_names = context_params["team_names"]

    context_params =
      if team_names do
        split = String.split(team_names, ", ")
        Map.put(context_params, "team_names", split)
      else
        context_params
      end

    case Storage.create_context(user_id, context_params) do
      {:ok, context} ->
        redirect(conn, to: Routes.storage_context_path(conn, :show, context))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    context =
      conn
      |> Session.current_user_id()
      |> Storage.get_context(id)
      |> Repo.preload(:teams)
      |> Repo.preload(:creator)

    render(conn, "show.html", context: context)
  end

  def edit(conn, %{"id" => id}) do
    context =
      conn
      |> Session.current_user_id()
      |> Storage.get_context(id)
      |> Repo.preload(:teams)

    team_names = Enum.map(context.teams, & &1.name)

    context =
      context
      |> Map.delete(:teams)
      |> Map.put(:team_names, team_names)

    changeset = Storage.context_changeset(context)

    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"id" => id, "context" => context_params}) do
    user_id = Session.current_user_id(conn)

    context =
      conn
      |> Session.current_user_id()
      |> Storage.get_context(id)
      |> Repo.preload(:teams)

    context_params = Map.put(context_params, "creator_id", user_id)

    team_names = context_params["team_names"]

    context_params =
      if team_names do
        split = String.split(team_names, ", ")
        Map.put(context_params, "team_names", split)
      else
        context_params
      end

    case Storage.update_context(user_id, context, context_params) do
      {:ok, context} ->
        redirect(conn, to: Routes.storage_context_path(conn, :show, context))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end
end
