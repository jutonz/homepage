defmodule Mix.Tasks.DialyzerPre do
  @moduledoc false
  use Mix.Task

  @impl Mix.Task
  @shortdoc "Create a _plts directory for dialyzer"
  @dir "_plts"
  def run(_) do
    File.mkdir_p!(@dir)
    IO.puts("Made #{@dir} directory.")
  end
end
