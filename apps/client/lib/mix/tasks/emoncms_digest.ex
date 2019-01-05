defmodule Mix.Tasks.EmoncmsDigest do
  use Mix.Task

  def run(_) do
    {:ok, _started} = Application.ensure_all_started(:client)
    Client.Email.emoncms_digest() |> Client.Mailer.deliver_now()
  end
end
