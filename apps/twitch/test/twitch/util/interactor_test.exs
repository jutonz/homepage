defmodule InteractorTest do
  use Twitch.DataCase, async: true
  alias Twitch.Util.Interactor
  alias Twitch.Util.Interactible

  defmodule __MODULE__.FirstStepNil do
    @behaviour Interactible
    def up(data) do
      assert data == nil
      {:ok, data}
    end

    def down(data), do: {:ok, data}
  end

  test "calls the first step with nil" do
    Interactor.perform([__MODULE__.FirstStepNil])
  end

  defmodule __MODULE__.FirstStepArg do
    @behaviour Interactible
    def up(data) do
      assert data == "woah"
      {:ok, data}
    end

    def down(data), do: {:ok, data}
  end

  test "passes the argument to the step if given" do
    Interactor.perform([{__MODULE__.FirstStepArg, "woah"}])
  end

  defmodule __MODULE__.LastStep do
    @behaviour Interactible
    def up(_data), do: {:ok, "abc123"}
    def down(data), do: {:ok, data}
  end

  test "returns the result of the last step" do
    assert {:ok, "abc123"} = Interactor.perform([__MODULE__.LastStep])
  end

  defmodule __MODULE__.FirstStepGood do
    @behaviour Interactible
    def up(_data), do: {:ok, "result of first step"}

    def down(data) do
      assert data == "result of first step"
      {:ok, data}
    end
  end

  defmodule __MODULE__.SecondStepBad do
    @behaviour Interactible
    def up(_data), do: {:error, "sad arg"}
    def down(data), do: {:ok, data}
  end

  test "calls down() on the first step when the second step fails" do
    result =
      Interactor.perform([
        __MODULE__.FirstStepGood,
        __MODULE__.SecondStepBad
      ])

    assert {:error, "sad arg"} = result
  end

  defmodule __MODULE__.OneGood do
    @behaviour Interactible
    def up(_data), do: {:ok, "result from step 1"}

    def down(data) do
      assert data == "result from step 1"
      {:ok, data}
    end
  end

  defmodule __MODULE__.TwoGood do
    @behaviour Interactible
    def up("result from step 1"), do: {:ok, "result from step 2"}

    def down(data) do
      assert data == "result from step 2"
      {:ok, data}
    end
  end

  defmodule __MODULE__.ThreeBad do
    @behaviour Interactible
    def up("result from step 2"), do: {:error, "bad!"}
    def down(data), do: {:ok, data}
  end

  test "when an intermediate step fails, calls down() with the last successful up()" do
    Interactor.perform([
      __MODULE__.OneGood,
      __MODULE__.TwoGood,
      __MODULE__.ThreeBad
    ])
  end
end
