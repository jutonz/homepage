defmodule ClientWeb.Api.FallbackController do
  use ClientWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    formatted_errors =
      Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
        Enum.reduce(opts, msg, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
        end)
      end)

    conn
    |> put_status(400)
    |> json(%{"error" => formatted_errors})
  end

  def call(conn, {:error, reason}) do
    conn
    |> put_status(400)
    |> json(%{"error" => reason})
  end
end
