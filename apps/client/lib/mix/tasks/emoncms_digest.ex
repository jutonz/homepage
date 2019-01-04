defmodule Mix.Tasks.EmoncmsDigest do
  use Mix.Task

  def run(_) do
    Client.Email.emoncms_digest() |> Client.Mailer.deliver_later()
  end
end
