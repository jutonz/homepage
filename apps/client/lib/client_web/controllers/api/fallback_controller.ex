defmodule ClientWeb.Api.FallbackController do
  use ClientWeb, :controller

  # This is getting a type mismatch as of Phoenix 1.5.9 and Plug 1.12.0. It
  # looks like Plug.t() is new now.
  @dialyzer {:unmatched_returns, call: 2}
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(400)
    |> json(%{"error" => Client.Util.attribute_errors(changeset)})
  end

  def call(conn, {:error, reason}) do
    conn
    |> put_status(400)
    |> json(%{"error" => reason})
  end
end
