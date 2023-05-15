defmodule Client.FileRenamerTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureLog
  alias Client.FileRenamer

  describe ".init/1" do
    test "stops if no path is given" do
      log =
        capture_log(fn ->
          assert FileRenamer.init([]) == :ignore
        end)

      msg = "No `path:` argument configured. Exiting."
      assert String.contains?(log, msg)
    end
  end

  describe ".handle_continue/2" do
    test "stops if the path doesn't exist on the filesystem" do
      path = "/does/not/exist"
      state = %{path: path}

      log =
        capture_log(fn ->
          result = FileRenamer.handle_continue(:check_path, state)
          assert {:stop, :normal, ^state} = result
        end)

      msg = "Path '#{path}' doesn't exist. Exiting"
      assert String.contains?(log, msg)
    end

    test "stops if the path isn't a directory" do
      path = Briefly.create!()
      state = %{path: path}

      log =
        capture_log(fn ->
          result = FileRenamer.handle_continue(:check_path, state)
          assert {:stop, :normal, ^state} = result
        end)

      msg = "Path '#{path}' exists, but isn't a directory. Exiting"
      assert String.contains?(log, msg)
    end

    test "is ok if the path is a directory" do
      path = Briefly.create!(directory: true)
      state = %{path: path}

      result = FileRenamer.handle_continue(:check_path, state)

      assert {:noreply, ^state} = result
    end
  end

  describe ".rename_files/1" do
    test "renames files" do
      dir = Briefly.create!(directory: true)
      file = Path.join(dir, "asdf.txt")
      File.write!(file, "")

      expected_name =
        file
        |> File.stat!([time: :posix])
        |> Map.get(:ctime)
        |> DateTime.from_unix!()
        |> DateTime.to_iso8601()
        |> Kernel.<>(".txt")

      FileRenamer.rename_files(dir)

      assert [^expected_name] = File.ls!(dir)
    end

    test "doesn't rename directories" do
      dir = Briefly.create!(directory: true)
      subdir = Path.join(dir, "subdir")
      File.mkdir!(subdir)

      FileRenamer.rename_files(dir)

      assert ["subdir"] = File.ls!(dir)
    end

    test "doesn't recurse into subdirectories" do
      dir = Briefly.create!(directory: true)
      subdir = Path.join(dir, "subdir")
      File.mkdir!(subdir)
      File.write(Path.join(subdir, "in_subdir.txt"), "")

      FileRenamer.rename_files(dir)

      assert ["subdir"] = File.ls!(dir)
      assert ["in_subdir.txt"] = File.ls!(subdir)
    end

    test "handles files which already have the right name" do
      dir = Briefly.create!(directory: true)
      file = Path.join(dir, "asdf.txt")
      File.write!(file, "")

      expected_name =
        file
        |> File.stat!([time: :posix])
        |> Map.get(:ctime)
        |> DateTime.from_unix!()
        |> DateTime.to_iso8601()
        |> Kernel.<>(".txt")

      File.rename!(file, Path.join(Path.dirname(file), expected_name))

      FileRenamer.rename_files(dir)

      assert [^expected_name] = File.ls!(dir)
    end
  end
end
