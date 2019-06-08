defmodule Mix.Tasks.Import.Channels do
  use Mix.Task
  import Ecto.Query
  alias Twitch.{Channel, Repo, GoogleRepo}

  @shortdoc "Import channels from google"
  def run(_) do
    {:ok, _started} = Application.ensure_all_started(:twitch)

    import_channels()
  end

  defp import_channels do
    GoogleRepo.transaction(fn ->
      channels_from_google_stream()
      |> Stream.map(&Channel.changeset(&1, %{}))
      |> Enum.each(&Repo.insert!/1)
    end)
  end

  defp channels_from_google_stream do
    query =
      from(ch in Channel,
        join: u in assoc(ch, :user),
        preload: [user: u]
      )

    GoogleRepo.stream(query)
  end
end
