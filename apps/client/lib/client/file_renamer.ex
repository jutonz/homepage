defmodule Client.FileRenamer do
  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    path = opts[:path]

    if path == nil do
      warn("No `path:` argument configured. Exiting.")
      :ignore
    else
      state = %{path: path}
      {:ok, state, {:continue, :check_path}}
    end
  end

  def handle_continue(:check_path, %{path: path} = state) do
    # TODO: Consider running these checks on every tick, not just at startup,
    # to handle the directory being deleted while the app is running
    cond do
      !File.exists?(path) ->
        warn("Path '#{path}' doesn't exist. Exiting.")
        {:stop, :normal, state}

      !File.dir?(path) ->
        warn("Path '#{path}' exists, but isn't a directory. Exiting")
        {:stop, :normal, state}

      true ->
        send(self(), :checkin)
        {:noreply, state}
    end
  end

  def handle_info(:checkin, %{path: path} = state) do
    rename_files(path)
    schedule_checkin()
    {:noreply, state}
  end

  def rename_files(path) do
    path
    |> File.ls!()
    |> Enum.map(fn basename -> Path.join(path, basename) end)
    |> Enum.reject(&File.dir?/1)
    |> Enum.each(&rename_file/1)
  end

  defp warn(msg) do
    Logger.warning("[#{__MODULE__}] #{msg}")
  end

  defp info(msg) do
    Logger.info("[#{__MODULE__}] #{msg}")
  end

  @one_minute 60_000
  @one_hour @one_minute * 60
  defp schedule_checkin do
    Process.send_after(self(), :checkin, @one_hour)
  end

  defp rename_file(path) do
    stat = File.stat!(path, time: :posix)
    created_at = DateTime.from_unix!(stat.mtime)
    basename = Path.basename(path)
    extname = Path.extname(basename)
    iso8601 = DateTime.to_iso8601(created_at)

    if !String.starts_with?(basename, iso8601) do
      new_name = "#{iso8601}-#{:rand.uniform(1_000_000)}#{extname}"
      new_path = Path.join(Path.dirname(path), new_name)
      info("Renaming '#{path}' to '#{new_path}'")
      File.rename!(path, new_path)
      info("Setting mtime of #{new_path} to #{stat.mtime}")
      File.touch!(new_path, stat.mtime)
    end
  end
end
