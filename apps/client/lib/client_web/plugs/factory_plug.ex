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
      factory_module = get_factory_module(opts)
      factory_name = String.replace(conn.request_path, opts[:at] <> "/", "")
      factory_function = build_factory_function(factory_name)

      with {:ok, result} <- call_factory_function(factory_module, factory_function, conn) do
        case opts[:repo].insert(result) do
          {:ok, record} ->
            conn
            |> put_resp_header("content-type", "application/json")
            |> send_resp(201, JSON.encode!(record))
            |> halt()

          {:error, changeset} ->
            IO.inspect(changeset)

            conn
            |> send_resp(400, "something went wrong")
        end
      else
        {:error, reason} ->
          conn
          |> send_resp(500, reason)
          |> halt()
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

  defp get_factory_module(opts) do
    module = Map.fetch!(opts, :factory)

    if !Code.ensure_loaded?(module) do
      raise "Couldn't find factory module #{module}. Did you configure #{__MODULE__} correctly?"
    end

    module
  end

  defp call_factory_function(factory_module, factory_function, conn) do
    cond do
      Kernel.function_exported?(factory_module, factory_function, 1) ->
        attrs =
          conn.body_params
          |> Enum.to_list()
          |> Enum.map(fn {key, value} -> {String.to_atom(key), value} end)
          |> Map.new()

        {:ok, apply(factory_module, factory_function, [attrs])}

      Kernel.function_exported?(factory_module, factory_function, 0) ->
        {:ok, apply(factory_module, factory_function, [])}

      true ->
        {:error,
         "Couldn't find matching factory. Expected #{factory_module} to define a function #{factory_function}/0 or #{factory_function}/1, but no such functions were found."}
    end
  end

  defp matches_request_path?(%Conn{request_path: path}, %{at: at}) do
    String.starts_with?(path, at)
  end
end
