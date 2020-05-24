defmodule ClientWeb.Api.FallbackController do
  use ClientWeb, :controller

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
