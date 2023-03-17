defmodule ClientWeb.Plugs.FactoryPlug do
  import Plug.Conn
  alias Plug.Conn

  def init(opts) do
    %{
      at: opts[:at],
      factory: opts[:factory],
      repo: opts[:repo]
    }
  end

  def call(%Conn{method: "POST"} = conn, opts) do
    if matches_request_path?(conn, opts) do
      factory_name = String.replace(conn.request_path, opts[:at] <> "/", "")
      factory_function = build_factory_function(factory_name)

      result =
        cond do
          Kernel.function_exported?(opts[:factory], factory_function, 1) ->
            attrs =
              conn.body_params
              |> Enum.to_list()
              |> Enum.map(fn {key, value} -> {String.to_atom(key), value} end)
              |> Map.new()

            apply(opts[:factory], factory_function, [attrs])

          Kernel.function_exported?(opts[:factory], factory_function, 0) ->
            apply(opts[:factory], factory_function, [])
        end

      case opts[:repo].insert(result) do
        {:ok, record} ->
          conn
          |> put_resp_header("content-type", "application/json")
          |> send_resp(201, Jason.encode!(record))
          |> halt()

        {:error, changeset} ->
          IO.inspect(changeset)

          conn
          |> send_resp(400, "something went wrong")
      end
    else
      conn
    end
  end

  def call(conn, _opts) do
    conn
  end

  defp build_factory_function(record) do
    record
    |> Kernel.<>("_factory")
    |> String.to_atom()
  end

  defp matches_request_path?(%Conn{request_path: path}, %{at: at}) do
    String.starts_with?(path, at)
  end
end
