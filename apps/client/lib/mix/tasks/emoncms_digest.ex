defmodule Mix.Tasks.EmoncmsDigest do
  use Mix.Task

  def run(_) do
    {:ok, _started} = Application.ensure_all_started(:timex)
    Client.Email.emoncms_digest() |> Client.Mailer.deliver_later()
  end
end
