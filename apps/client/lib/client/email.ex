defmodule Client.Email do
  use Bamboo.Phoenix, view: ClientWeb.EmailView

  def test do
    new_email()
    |> to("jutonz42@gmail.com")
    |> from("jutonz42@gmail.com")
    |> subject("Test")
    |> render("test.text", name: "Me!")
  end
end
