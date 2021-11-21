defmodule InteractorTest do
  use Twitch.DataCase, async: true
  alias Twitch.Util.Interactor

  defmodule __MODULE__.OneStep do
    @behaviour Twitch.Util.Interactible
    def up(:context, ["arg"]), do: {:ok, :context}
    def down(context, _args), do: {:ok, context}
  end

  test "calls the step with the context and arguments" do
    Interactor.perform(:context, [{__MODULE__.OneStep, ["arg"]}])
  end

  defmodule __MODULE__.ContextReturn do
    @behaviour Twitch.Util.Interactible
    def up(_context, []), do: {:ok, :modified_context}
    def down(context, _args), do: {:ok, context}
  end

  test "it returns {:ok, context}" do
    result = Interactor.perform(:context, [{__MODULE__.ContextReturn, []}])
    assert {:ok, :modified_context} = result
  end

  defmodule __MODULE__.ErrorReturn do
    @behaviour Twitch.Util.Interactible
    def up(_context, []), do: {:error, :a_problem}
    def down(context, _args), do: {:ok, context}
  end

  test "it returns {:error, context} if something goes wrong" do
    result = Interactor.perform(:context, [{__MODULE__.ErrorReturn, []}])
    assert {:error, :a_problem} = result
  end

  defmodule __MODULE__.ContextStepOne do
    @behaviour Twitch.Util.Interactible
    def up(:context, []), do: {:ok, :modified_context}
    def down(context, _args), do: {:ok, context}
  end

  defmodule __MODULE__.ContextStepTwo do
    @behaviour Twitch.Util.Interactible
    def up(:modified_context, []), do: {:ok, :modified_context}
    def down(context, _args), do: {:ok, context}
  end

  test "passes the modified context to the next step" do
    Interactor.perform(:context, [
      {__MODULE__.ContextStepOne, []},
      {__MODULE__.ContextStepTwo, []}
    ])
  end

  defmodule __MODULE__.ErrorStepOne do
    @behaviour Twitch.Util.Interactible
    def up(:context, []), do: {:ok, "step 1 context"}
    def down("down call from step 2", _args), do: {:ok, "down call from step 1"}
  end

  defmodule __MODULE__.ErrorStepTwo do
    @behaviour Twitch.Util.Interactible
    def up("step 1 context", []), do: {:ok, "step 2 context"}
    def down("error in step 3", []), do: {:ok, "down call from step 2"}
  end

  defmodule __MODULE__.ErrorStepThree do
    @behaviour Twitch.Util.Interactible
    def up("step 2 context", []), do: {:error, "error in step 3"}
    def down(context, []), do: {:ok, context}
  end

  test "calls down/1 on previous steps when an error occurs" do
    result =
      Interactor.perform(:context, [
        {__MODULE__.ErrorStepOne, []},
        {__MODULE__.ErrorStepTwo, []},
        {__MODULE__.ErrorStepThree, []}
      ])

    assert {:error, "down call from step 1"} = result
  end

  # TODO: What happens when a down/1 step fails?
end
