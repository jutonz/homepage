defmodule Client.Email do
  use Bamboo.Phoenix, view: ClientWeb.EmailView

  def test do
    new_email()
    |> to("jutonz42@gmail.com")
    |> from("jutonz42@gmail.com")
    |> subject("Test")
    |> render("test.text", name: "Me!")
  end

  def emoncms_digest(recipient \\ "jutonz42@gmail.com") do
    {:ok, values} = Emoncms.get_values()
    [_timestamp, first_value] = values |> Enum.at(0)
    [_timestamp, last_value] = values |> Enum.at(-1)
    energy_generated = last_value - first_value

    new_email()
    |> to(recipient)
    |> from("jutonz42@gmail.com")
    |> subject("Emoncms recap")
    |> render("emoncms_digest.text", values: values, generated_in_last_day: energy_generated)
  end
end
