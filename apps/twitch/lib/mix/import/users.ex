defmodule Mix.Tasks.Import.Users do
  use Mix.Task
  import Ecto.Query
  alias Twitch.{User, Repo, GoogleRepo}

  @shortdoc "Import users from google"
  def run(_) do
    {:ok, _started} = Application.ensure_all_started(:twitch)

    import_users()
  end

  defp import_users do
    GoogleRepo.transaction(fn ->
      users_from_google_stream()
      |> Stream.map(&User.changeset(&1, %{}))
      |> Enum.each(&Repo.insert!/1)
    end)
  end

  defp users_from_google_stream do
    query =
      from(u in User,
        join: ch in assoc(u, :twitch_channels),
        preload: [twitch_channels: ch]
      )

    GoogleRepo.stream(query)
  end
end
