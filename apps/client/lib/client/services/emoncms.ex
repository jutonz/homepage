defmodule Client.Emoncms do
  def send_digest do
    Client.Email.emoncms_digest() |> Client.Mailer.deliver_later!()
  end
end
