defmodule Mix.Tasks.Import.GamblingEvents do
  use Mix.Task
  import Ecto.Query
  alias Twitch.{GamblingEvent, GoogleRepo}

  @shortdoc "Import gambling events from google"
  def run(_) do
    {:ok, _started} = Application.ensure_all_started(:twitch)

    import_gambling_events()
  end

  defp import_gambling_events do
    GoogleRepo.transaction(fn ->
      gambling_events_from_google_stream()
      |> Enum.map(&Twitch.Datastore.GamblingEvent.persist/1)
    end)
  end

  defp gambling_events_from_google_stream do
    query =
      from(ge in GamblingEvent,
        join: ev in assoc(ge, :twitch_event),
        preload: [twitch_event: ev]
      )

    GoogleRepo.stream(query)
  end
end
