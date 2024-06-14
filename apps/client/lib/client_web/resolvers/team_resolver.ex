defmodule ClientWeb.TeamResolver do
  alias Client.{Team, Repo, User}

  def get_user_teams(_parent, _args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         user <- user |> Repo.preload(:teams) do
      {:ok, user.teams}
    else
      _ -> {:error, "Could not fetch teams"}
    end
  end

  def get_team(_parent, args, %{context: %{current_user: current_user}}) do
    with {:ok, team_id} <- args |> Map.fetch(:id),
         {:ok, team} <- current_user |> User.get_team(team_id),
         do: {:ok, team},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Could not find matching team"}
           )
  end

  def create_team(_parent, args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         changeset <- %Team{} |> Team.changeset(args),
         changeset <- changeset |> Ecto.Changeset.put_assoc(:users, [user]),
         {:ok, team} <- changeset |> Repo.insert() do
      {:ok, team}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, changeset |> extract_errors}

      {:error, reason} ->
        {:error, reason}

      _ ->
        {:error, "Could not create team"}
    end
  end

  def delete_team(_parent, args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         {:ok, team_id} <- args |> Map.fetch(:id),
         {:ok, team} <- user |> User.get_team(team_id),
         changeset <- team |> Team.changeset(),
         {:ok, team} <- changeset |> Repo.delete(),
         do: {:ok, team},
         else:
           (
             {:error, %Ecto.Changeset{} = changeset} ->
               {:error, changeset |> extract_errors}

             {:eror, reason} ->
               {:error, reason}

             _ ->
               {:error, "Could not delete team"}
           )
  end

  def rename_team(_parent, args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         {:ok, team_id} <- args |> Map.fetch(:id),
         {:ok, team} <- user |> User.get_team(team_id),
         changeset <- team |> Team.changeset(args),
         {:ok, team} <- changeset |> Repo.update(),
         do: {:ok, team},
         else:
           (
             {:error, %Ecto.Changeset{} = changeset} ->
               {:error, changeset |> extract_errors}

             {:eror, reason} ->
               {:error, reason}

             _ ->
               {:error, "Could not rename team"}
           )
  end

  def get_team_users(_parent, args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         {:ok, team_id} <- args |> Map.fetch(:team_id),
         {:ok, team} <- user |> User.get_team(team_id),
         withUsers <- team |> Repo.preload(:users),
         do: {:ok, withUsers.users},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Could not retrieve users"}
           )
  end

  def get_team_user(_parent, args, %{context: context}) do
    with {:ok, _user} <- context |> Map.fetch(:current_user),
         {:ok, team_id} <- args |> Map.fetch(:team_id),
         {:ok, user_id} <- args |> Map.fetch(:user_id),
         {:ok, user} <- Team.get_team_user(team_id, user_id),
         do: {:ok, user},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Could not fetch user"}
           )
  end

  def join_team(_parent, args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         {:ok, name} <- args |> Map.fetch(:name),
         {:ok, team} <- name |> Team.get_by_name(),
         {:ok, _user} <- user |> User.join_team(team),
         do: {:ok, team},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to join team"}
           )
  end

  def leave_team(_parent, args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         {:ok, team_id} <- args |> Map.fetch(:id),
         {:ok, team} <- user |> User.get_team(team_id),
         {:ok, team} <- user |> User.leave_team(team),
         do: {:ok, team},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to join team"}
           )
  end

  def extract_errors(%Ecto.Changeset{} = changeset) do
    changeset.errors
    |> Enum.map(fn error ->
      attr = error |> elem(0) |> to_string |> String.capitalize()
      message = error |> elem(1) |> elem(0)
      "#{attr} #{message}"
    end)
  end
end
