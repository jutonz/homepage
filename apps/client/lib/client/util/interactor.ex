defmodule Client.Util.Interactor do
  alias Client.Util.Interactor.PerformedStep

  def perform(interactibles) do
    interactibles
    |> Enum.map(&expand_input(&1))
    |> perform([])
  end

  defp perform([], performed) do
    result =
      case performed do
        [] -> nil
        [first | _rest] -> first.result
      end

    {:ok, result}
  end

  defp perform([{interactible, arg} | rest], performed) do
    actualized_arg = maybe_curry_arg(arg, performed)

    case apply(interactible, :up, actualized_arg) do
      {:ok, result} ->
        perfomed_step = %PerformedStep{
          interactible: interactible,
          result: result,
          actualized_arg: actualized_arg
        }
        perform(rest, [perfomed_step | performed])

      {:error, reason} ->
        rollback(performed)
        {:error, reason}

      other ->
        error = """
        An Interatible returned something other than {:ok, result} or {:error, reason}.

        Please adjust #{interactible}.up such that it always returns one of these results.

        The actual result was: #{inspect(other)}
        """

        raise error
    end
  end

  def rollback([]), do: :noop

  def rollback([first | rest]) do
    apply(first.interactible, :down, [first.result])
    rollback(rest)
  end


  defp expand_input({interactible, arg}) when is_list(arg),
    do: {interactible, arg}
  defp expand_input({interactible, arg}), do: {interactible, [arg]}
  defp expand_input(interactible), do: {interactible, :curry}

  def maybe_curry_arg(:curry, []), do: [nil]
  def maybe_curry_arg(:curry, [first | _rest]), do: [first.result]
  def maybe_curry_arg(arg, _performed), do: arg
end
